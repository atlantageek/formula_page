module FormulaPage
  class EquationParser
    TOK_TYPE_NOOP      = "noop";
    TOK_TYPE_OPERAND   = "operand";
    TOK_TYPE_PATH      = "path";
    TOK_TYPE_FUNCTION  = "function";
    TOK_TYPE_SUBEXPR   = "subexpression";
    TOK_TYPE_ARGUMENT  = "argument";
    TOK_TYPE_OP_PRE    = "operator-prefix";
    TOK_TYPE_OP_IN     = "operator-infix";
    TOK_TYPE_OP_POST   = "operator-postfix";
    TOK_TYPE_WSPACE    = "white-space";
    TOK_TYPE_UNKNOWN   = "unknown"

    TOK_SUBTYPE_START       = "start";
    TOK_SUBTYPE_STOP        = "stop";

    TOK_SUBTYPE_TEXT        = "text";
    TOK_SUBTYPE_NUMBER      = "number";
    TOK_SUBTYPE_LOGICAL     = "logical";
    TOK_SUBTYPE_ERROR       = "error";
    TOK_SUBTYPE_RANGE       = "range";

    TOK_SUBTYPE_MATH        = "math";
    TOK_SUBTYPE_CONCAT      = "concatenate";
    TOK_SUBTYPE_INTERSECT   = "intersect";
    TOK_SUBTYPE_UNION       = "union";

  def self.parse(formula)
    FormulaPage::TokenList.clear()
    FormulaPage::TokenStack.clear()
    working_formula=formula.strip
    inString = false;
    inPath = false;
    inRange = false;
    inError = false;
    regexSN = /^[1-9]{1}(\.[0-9]+)?E{1}$/

    if (working_formula[0] == '=')
      working_formula = working_formula[1..-1]
    end

    cur_pos = 0
    token_value = ""

    #Start parsing loop
    while cur_pos < working_formula.length do

      #Ending tokens
      if (inString)
        if (working_formula[cur_pos] == "\"")
          if (cur_pos < working_formula.length && working_formula[cur_pos + 1] == "\"")
            token_value  << '"'
          else
            inString = false;
            FormulaPage::TokenList.add(token_value,TOK_TYPE_OPERAND, TOK_SUBTYPE_TEXT)
            token_value = ""
          end
        end
      end

      if (inPath)
        if (working_formula[cur_pos] == "\'")
            inPath = false;
            FormulaPage::TokenList.add(token_value,TOK_TYPE_PATH, TOK_SUBTYPE_TEXT)
            token_value = ""
        end
      end

      if (inRange)
        if (working_formula[cur_pos] == "]")
          inRange = false
            #FormulaPage::TokenList.add(token_value,TOK_TYPE_RANGE, TOK_SUBTYPE_TEXT)
            token_value = ""
        end
      end

      #Character evaluation
      if (working_formula[cur_pos] == "\"")
        if (token_value.length > 0) #Not the beginning of a token
          FormulaPage::TokenList.add(token_value, TOK_TYPE_UNKNOWN,"")
          token_value = ""
        end
        inString = true;
        cur_pos = cur_pos + 1
        next #Will not put quotes in the string
      elsif (working_formula[cur_pos] == "\'")
        if (token_value.length > 0) #Not the beginning of a token
          FormulaPage::TokenList.add(token_value, TOK_TYPE_UNKNOWN,"")
          token_value = ""
        end
        inPath = true;
        cur_pos = cur_pos + 1
        next #Will not put quotes in the path
      elsif (working_formula[cur_pos] == "[")
        inRange = true
        token_value += working_formula[cur_pos]
        cur_pos = cur_pos + 1
        next #Will not put quotes in the path
      elsif (working_formula[cur_pos] == "{")
        if (token_value.length > 0)
          FormulaPage::TokenList.add(token_value, TOK_TYPE_UNKNOWN,"")
          token_value=""
        cur_pos = cur_pos + 1
        next #Will not put quotes in the path
        end
        FormulaPage::TokenStack.push(FormulaPage::TokenList.add("ARRAY",TOK_TYPE_FUNCTION, TOK_SUBTYPE_START))
        FormulaPage::TokenStack.push(FormulaPage::TokenList.add("ARRAYROW",TOK_TYPE_FUNCTION, TOK_SUBTYPE_START))
        inRange = true
        token_value += working_formula[cur_pos]
        cur_pos = cur_pos + 1
        next
      elsif working_formula[cur_pos] == "}"
        if (token_value.length > 0)
          FormulaPage::TokenList.add(token_value, TOK_TYPE_OPERAND,"")
        end
        FormulaPage::TokenList.addRef(FormulaPage::TokenStack.pop)
        FormulaPage::TokenList.addRef(FormulaPage::TokenStack.pop)
        cur_pos = cur_pos + 1
        next
      elsif working_formula[cur_pos] == ' '
        if (token_value.length > 0 )
          FormulaPage::TokenList.add(token_value, TOK_TYPE_OPERAND, "")
          token_value = ""
        end
        FormulaPage::TokenList.add("", TOK_TYPE_WSPACE,"")
        cur_pos = cur_pos + 1
        next
      elsif (",>=,<=,<>,".index("," + working_formula[cur_pos..(cur_pos+1)] + ",") == -1)
        if (token_value.length > 0)
          FormulaPage::TokenList.add(token_value, TOK_TYPE_OPERAND, "")
          token_value = ""
        end
        FormulaPage::TokenList.add(working_formula[cur_pos..(cur_pos+1)],TOK_TYPE_OP_IN,TOK_SUBTYPE_LOGICAL);
        cur_pos = cur_pos + 2
        next
      elsif ("+-*/^&=><".index(working_formula[cur_pos]) == -1)
        if (token_value.length > 0)
          FormulaPage::TokenList.add(token_value, TOK_TYPE_OPERAND, "")
          token_value = ""
        end
        FormulaPage::TokenList.add(working_formula[cur_pos],TOK_TYPE_OP_POST,"");
        cur_pos = cur_pos + 1
        next
      elsif ("%".index(working_formula[cur_pos]) == -1)
        if (token_value.length > 0)
          FormulaPage::TokenList.add(token_value, TOK_TYPE_OPERAND, "")
          token_value = ""
        end
        FormulaPage::TokenList.add(working_formula[cur_pos],TOK_TYPE_OP_POST,"");
        cur_pos = cur_pos + 1
        next
      elsif (working_formula[cur_pos] == "(")
        if (token_value.length > 0)
          FormulaPage::TokenStack.push(FormulaPage::TokenList.add(token_value, TOK_TYPE_FUNCTION, TOK_TYPE_START))
          token_value = ""
        else
          FormulaPage::TokenStack.push(FormulaPage::TokenList.add("", TOK_TYPE_SUBEXPR, TOK_TYPE_START))
        end
        cur_pos = cur_pos + 1
        next
      elsif (working_formula[cur_pos] == ",")
        if (token_value.length > 0)
          FormulaPage::TokenList.add(token_value, TOK_TYPE_OPERAND)
          token_value = ""
        end
        if (FormulaPage::TokenStack.type() == TOK_TYPE_FUNCTION)
          FormulaPate::TokenList.add(working_formula[cur_pos], TOK_TYPE_OP_IN, TOK_SUBTYPE_UNION)
        else
          FormulaPage::TokenList.add(working_formula[cur_pos], TOK_TYPE_ARGUMENT, "")
        end
        cur_pos = cur_pos + 1
        next
      elsif (working_formula[cur_pos] == ")")
        if (token_value.length > 0)
          FormulaPage::TokenList.add(token_value, TOK_TYPE_OPERAND)
          token_value = ""
        end
        FormulaPage::TokenList.addRef(FormulaPage::TokenStack.pop)
        cur_pos = cur_pos + 1
        next
      end
      puts "#{token_value} #{cur_pos}"
      token_value << working_formula[cur_pos]
      cur_pos = cur_pos + 1
    end
  end
  end
end

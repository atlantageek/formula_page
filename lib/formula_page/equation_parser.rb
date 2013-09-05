class FormulaParser
  TOK_TYPE_NOOP      = "noop";
  TOK_TYPE_OPERAND   = "operand";
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
end

class FTokens
    @@items = Array.new
    def self.add(value, type,subtype = nil)
      if (subtype.nil?)
        subtype = '';
      end
      token = FToken.new(value, type, subtype)
      @@items.push(token)
      return token
    end
end

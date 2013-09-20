require 'spec_helper'
describe FormulaPage do
  it "should allow the creation of a token" do
    f = FormulaPage::Token.new('a','b','c')
    f.should_not be_nil
  end

  it "should allow the adding of a token to the list" do
    token = FormulaPage::TokenList.add('a','b','c')
    token.should_not be_nil
    token.class.name.should == 'FormulaPage::Token'
    FormulaPage::TokenList.get_index.should == 0
    #FormulaPage::TokenList.eof?.should == true
    FormulaPage::TokenList.get_items.length.should == 1
    token = FormulaPage::TokenList.add('d','e','f')
    FormulaPage::TokenList.get_items.length.should == 2
  end

  it "should allow the positioning of the current index" do
    FormulaPage::TokenList.clear()
    token = FormulaPage::TokenList.add('a','b','c')
    token = FormulaPage::TokenList.add('d','e','f')
    FormulaPage::TokenList.reset()
    FormulaPage::TokenList.get_items.length.should == 2
    FormulaPage::TokenList.bof?.should == true
    FormulaPage::TokenList.eof?.should == false
    FormulaPage::TokenList.moveNext()
    FormulaPage::TokenList.get_index.should == 1
    FormulaPage::TokenList.bof?.should == false
    FormulaPage::TokenList.eof?.should == true
  end

  it "should allow the adding to the token stack" do
    FormulaPage::TokenList.clear()
    f = FormulaPage::Token.new('a','b','c')
    FormulaPage::TokenStack.size().should == 0
    FormulaPage::TokenStack.push(f)
    FormulaPage::TokenStack.size().should == 1
    FormulaPage::TokenStack.pop()
    FormulaPage::TokenStack.size().should == 0
    FormulaPage::TokenStack.push(FormulaPage::Token.new('a','b','c'))
    FormulaPage::TokenStack.push(FormulaPage::Token.new('d','e','f'))
    FormulaPage::TokenStack.size().should == 2
    f = FormulaPage::TokenStack.pop()
    FormulaPage::TokenStack.size().should == 1
    f.value.should == 'd'
    FormulaPage::TokenStack.value().should == 'a'
  end

  it "should parse strings" do
    FormulaPage::EquationParser.parse('="bacon"')
    FormulaPage::TokenList.get_items.length.should == 1
    token = FormulaPage::TokenList.current
    token.value.should == "bacon"
    token.type.should == FormulaPage::EquationParser::TOK_TYPE_OPERAND
    token.subtype.should == FormulaPage::EquationParser::TOK_SUBTYPE_TEXT

    FormulaPage::EquationParser.parse("='path'")
    FormulaPage::TokenList.get_items.length.should == 1
    token = FormulaPage::TokenList.current
    token.value.should == "path"
    token.type.should == FormulaPage::EquationParser::TOK_TYPE_PATH
    token.subtype.should == FormulaPage::EquationParser::TOK_SUBTYPE_TEXT
  end
end

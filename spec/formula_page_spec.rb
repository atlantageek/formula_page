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
end

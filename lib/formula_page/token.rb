module FormulaPage
  class Token
    attr_accessor :value, :type, :subtype
    def initialize(value, type, subtype)
      @value = value
      @type = type
      @subtype = subtype
    end

  end
end

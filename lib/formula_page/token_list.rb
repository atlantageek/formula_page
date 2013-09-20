module FormulaPage
  class TokenList
    @@items = Array.new()
    @@index = 0

    def self.get_items()
      @@items
    end

    def self.get_index()
      @@index
    end


    def self.add(value, type,subtype = nil)
      if (subtype.nil?)
        subtype = '';
      end
      token = Token.new(value, type, subtype)
      @@items.push(token)
      return token
    end

    def self.addRef(token)
      items.push(token)
    end

    def self.clear
      @@index = 0
      @@items=Array.new()
    end
    def self.reset
      @@index = 0
    end

    def self.bof?
      @@index <= 0
    end

    def self.eof?
      @@index >= @@items.length - 1
    end

    def self.moveNext
      if self.eof?
        false
      else
        @@index += 1
        true
      end
    end
    def self.current
      return false if @@items.length == 0
      return @@items[@@index]
    end
    def self.next
      if eof?()
        return nil
      else
        return @@items[@@index ]
      end
    end
    def self.prev
      if @@index < 1
        return nil
      else
        return @@items[@@index - 1]
      end
    end
  end
end

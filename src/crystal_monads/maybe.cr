module CrystalMonads
  module Maybe
    def self.build(value)
      if value.nil?
        None.new
      else
        Some.new(value)
      end
    end
  end

  class Some(T)
    def initialize(@value : T)
    end

    def bind(proc : Proc, *args)
      proc.call(@value, *args)
    end

    def bind(*args, &block : T -> _)
      yield(@value, *args)
    end

    def bind(&block : T -> _)
      yield(@value)
    end
  end

  class None
    def initialize
    end

    def value
      nil
    end

    def bind(proc : Proc, *args)
      self
    end

    def bind(*args, &block)
      self
    end

    def bind(&block)
      self
    end

    def to_s
      "None()"
    end
  end
end

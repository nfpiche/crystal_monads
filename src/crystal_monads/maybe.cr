module CrystalMonads
  module Maybe
    def self.lift(value)
      if value.nil?
        None.new
      else
        Some.new(value)
      end
    end
  end

  class Some(T)
    getter :value

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

    def fmap(proc : Proc, *args)
      Maybe.lift(proc.call(@value, *args))
    end

    def fmap(*args, &block : T -> _)
      Maybe.lift(yield(@value, *args))
    end

    def fmap(&block : T -> _)
      Maybe.lift(yield(@value))
    end

    def or(proc : Proc, *args)
      self
    end

    def or(*args, &block)
      self
    end

    def or(&block)
      self
    end

    def to_s
      "Some(#{value})"
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

    def fmap(proc : Proc, *args)
      self
    end

    def fmap(*args, &block)
      self
    end

    def fmap(&block)
      self
    end

    def or(proc : Proc, *args)
      proc.call(*args)
    end

    def or(*args, &block)
      yield(*args)
    end

    def or(&block)
      yield
    end

    def to_s
      "None()"
    end
  end
end

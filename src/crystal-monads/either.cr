module CrystalMonads
  class Either(T)
    getter :value

    def initialize(@value : T)
    end

    def to_either
      self
    end

    class Right(T) < Either(T)
      def fmap(*args, &block : T -> U)
        Right.new(bind { yield @value, *args })
      end

      def fmap(&block : T -> U)
        Right.new(bind(&block))
      end

      def fmap(*args)
        Right.new(bind(*args))
      end

      def bind(*args, &block : T -> U)
        yield(@value, *args)
      end

      def bind(&block : T -> U)
        yield(@value)
      end

      def bind(*args)
        func, rest = args
        raise ArgumentError.new("First arg must be callable")  unless func.responds_to? :call
        func.call(@value, rest)
      end

      def or(*args, &block : T -> U)
        self
      end

      def or(&block : T -> U)
        self
      end

      def or(*args)
        self
      end

      def left? : Bool
        false
      end

      def right? : Bool
        true
      end

      def to_s : String
        "Right(#{@value})"
      end
    end

    class Left(T) < Either(T)
      def bind(*args, &block : T -> U)
        self
      end

      def bind(&block : T -> U)
        self
      end

      def bind(*args)
        self
      end

      def fmap(*args, &block : T -> U)
        self
      end

      def fmap(&block : T -> U)
        self
      end

      def fmap(*args)
        self
      end

      def or(*args, &block : T -> U)
        yield(@value, *args)
      end

      def or(&block : T -> U)
        yield(@value)
      end

      def left? : Bool
        true
      end

      def right? : Bool
        false
      end

      def to_s : String
        "Left(#{@value})"
      end
    end
  end
end

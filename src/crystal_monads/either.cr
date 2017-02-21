module CrystalMonads
  class Either(T)
    getter :value

    def initialize(@value : T)
    end

    def to_either
      self
    end

    def right? : Bool
      self.is_a? Right
    end

    def left? : Bool
      self.is_a? Left
    end

    class Right(T) < Either(T)
      def fmap(*args, &block : T -> _)
        Right.new(bind { yield @value, *args })
      end

      def fmap(&block : T -> _)
        Right.new(bind(&block))
      end

      def fmap(*args)
        Right.new(bind(*args))
      end

      def bind(*args, &block : T -> _)
        yield(@value, *args)
      end

      def bind(proc : Proc, *args)
        proc.call(@value, *args)
      end

      def bind(&block : T -> _)
        yield(@value)
      end

      def or(proc : Proc, *args)
        self
      end

      def or(*args, &block : T -> _)
        self
      end

      def or(&block : T -> _)
        self
      end

      def to_s : String
        "Right(#{@value})"
      end
    end

    class Left(T) < Either(T)
      def fmap(*args, &block : T -> _)
        self
      end

      def fmap(&block : T -> _)
        self
      end

      def fmap(*args)
        self
      end

      def bind(*args, &block : T -> _)
        self
      end

      def bind(proc : Proc, *args)
        self
      end

      def bind(&block : T -> _)
        self
      end

      def or(proc : Proc, *args)
        proc.call(@value, *args)
      end

      def or(*args, &block : T -> _)
        yield(@value, *args)
      end

      def or(&block : T -> _)
        yield(@value)
      end

      def to_s : String
        "Left(#{@value})"
      end
    end
  end
end

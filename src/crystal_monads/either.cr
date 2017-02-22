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

      def or(proc : Proc, *args) : Right(T)
        self
      end

      def or(*args, &block : T -> _) : Right(T)
        self
      end

      def or(&block : T -> _) : Right(T)
        self
      end

      def to_s : String
        "Right(#{@value})"
      end

      def to_maybe : CrystalMonads::Maybe::Some(T)
        CrystalMonads::Maybe::Some.new(@value)
      end
    end

    class Left(T) < Either(T)
      def fmap(*args, &block : T -> _) : Left(T)
        self
      end

      def fmap(&block : T -> _) : Left(T)
        self
      end

      def fmap(*args) : Left(T)
        self
      end

      def bind(*args, &block : T -> _) : Left(T)
        self
      end

      def bind(proc : Proc, *args) : Left(T)
        self
      end

      def bind(&block : T -> _) : Left(T)
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

      def to_maybe : CrystalMonads::Maybe::None
        CrystalMonads::Maybe::None.new
      end
    end
  end
end

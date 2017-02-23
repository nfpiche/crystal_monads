module CrystalMonads
  abstract class Maybe
    def self.lift(value : Nil)
      CrystalMonads::Maybe::None.new
    end

    def self.lift(value)
      CrystalMonads::Maybe::Some.new(value)
    end

    class Some(T) < Maybe
      getter :value

      def initialize(@value : T)
      end

      def bind(proc : Proc, *args)
        proc.call(@value, *args)
      end

      def bind(*args, &block : T -> _)
        yield(@value, *args)
      end

      def fmap(proc : Proc, *args)
        Maybe.lift(proc.call(@value, *args))
      end

      def fmap(*args, &block : T -> _)
        Maybe.lift(yield(@value, *args))
      end

      def or(proc : Proc, *args) : Some(T)
        self
      end

      def or(*args, &block) : Some(T)
        self
      end

      def to_s : String
        "Some(#{value})"
      end
    end

    class None < Maybe
      def initialize
      end

      def value : Nil
        nil
      end

      def bind(proc : Proc, *args) : None
        self
      end

      def bind(*args, &block) : None
        self
      end

      def fmap(proc : Proc, *args) : None
        self
      end

      def fmap(*args, &block) : None
        self
      end

      def or(proc : Proc, *args)
        proc.call(*args)
      end

      def or(*args, &block)
        yield(*args)
      end

      def to_s : String
        "None()"
      end
    end
  end
end

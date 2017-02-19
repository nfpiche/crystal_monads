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
        func.call(@value, rest)
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

      def fmap(&block : T -> U)
        self
      end

      def or(&block)
        yield(@value)
      end

      def or(*args)
        args[0]
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

    module Mixin
      def self.right(value) : Right
        Right.new(value)
      end

      def self.left(value) : Left
        Left.new(value)
      end
    end
  end
end

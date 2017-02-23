module CrystalMonads
  abstract class Try
    def self.try(*args, &block)
      begin
        Success.new(yield)
      rescue ex
        raise ex unless args.includes? ex.class
        Failure.new(ex)
      end
    end

    def self.try(&block)
      begin
        Success.new(yield)
      rescue ex
        Failure.new(ex)
      end
    end

    def success? : Bool
      is_a? Success
    end

    def failure? : Bool
      is_a? Failure
    end

    class Success(T) < Try
      getter :value

      def initialize(@value : T)
      end

      def exception : Nil
        nil
      end
    end

    class Failure(Exception) < Try
      getter :exception

      def initialize(@exception : Exception)
      end

      def value : Nil
        nil
      end
    end
  end
end

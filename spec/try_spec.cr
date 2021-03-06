require "./spec_helper"

describe CrystalMonads::Try do
  describe "#try" do
    context "no exception is raised" do
      it "returns a Success with the result of block when no exceptions passed in" do
        result = CrystalMonads::Try.try() { 5 }
        result.should be_a CrystalMonads::Try::Success(Int32)
        result.value.should eq(5)
      end

      it "returns a Success with the result of block when one or more exceptions passed in" do
        result = CrystalMonads::Try.try() { 5 }
        result.should be_a CrystalMonads::Try::Success(Int32)
        result.value.should eq(5)
      end
    end

    context "an exception is raised" do
      it "returns a Failure with the Exception" do
        result = CrystalMonads::Try.try() { 5 / 0 }
        result.should be_a CrystalMonads::Try::Failure(Exception)
        result.exception.should be_a DivisionByZero
      end

      it "returns a Failure only if Exception matches one passed in" do
        result = CrystalMonads::Try.try(DivisionByZero, ArgumentError) { 5 / 0 }
        result.should be_a CrystalMonads::Try::Failure(Exception)
        result.exception.should be_a DivisionByZero
      end

      it "raises exception if non expected Exception is raised" do
        expect_raises(DivisionByZero) do
          CrystalMonads::Try.try(ArgumentError) { 5 / 0 }
        end
      end
    end
  end

  describe CrystalMonads::Try::Success do
    success_try = CrystalMonads::Try.try() { 5 }

    describe "#success" do
      it "returns true for Success object" do
        success_try.success?.should be_true
      end
    end

    describe "#failure" do
      it "returns false for Success object" do
        success_try.failure?.should be_false
      end
    end

    describe "#bind" do
      it "returns the value that a block evaluates to" do
        success_try.bind { |value| value + 5 }.should eq(10)
      end

      it "returns the value that a block with arguments evaluates to" do
        success_try.bind(10) { |value, c| value + c.as(Int32) }.should eq(15)
      end
    end
  end

  describe CrystalMonads::Try::Failure do
    failure_try = CrystalMonads::Try.try() { 5 / 0 }

    describe "#success" do
      it "returns false for Failure object" do
        failure_try.success?.should be_false
      end
    end

    describe "#failure" do
      it "returns false for Failure object" do
        failure_try.failure?.should be_true
      end
    end

    describe "#bind" do
      it "returns self and ignores block" do
        failure_try.bind { |value| value.should be_false}.should eq(failure_try)
      end

      it "returns self and ignores block with arguments" do
        failure_try.bind(10) { |value, c| c.as(Int32).should be_false }.should eq(failure_try)
      end
    end
  end
end

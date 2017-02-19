require "./spec_helper"

describe CrystalMonads::Either::Right do
  right = CrystalMonads::Either::Right.new(5)

  describe ".bind" do
    it "passes extra arguments to block" do
      right.bind(:foo) do |value, c|
        value.as(Int32).should eq(5)
        c.as(Symbol).should eq(:foo)
      end
    end

    it "passes extra arguments to proc" do
      proc = -> (value : Int32, c : Symbol) do
        value.should eq(5)
        c.should eq(:foo)
        true
      end

      right.bind(proc, :foo).should be_true
    end

    it "uses block when a block is given" do
      right.bind { |x| x + 5 }.should eq(10)
    end
  end

  describe ".fmap" do
    it "calls method when a mehtod is given, then wraps in Right" do
      result = right.fmap(&.succ)
      result.should be_a CrystalMonads::Either::Right(Int32)
      result.value.should eq(6)
    end

    it "uses a block when a block is given, then wraps in Right" do
      result = right.fmap { |x| x + 5 }
      result.should be_a CrystalMonads::Either::Right(Int32)
      result.value.should eq(10)
    end

    it "can be chained with other Right methods" do
      result = right.fmap(&.succ).fmap { |x| x + 5 }
      result.should be_a CrystalMonads::Either::Right(Int32)
      result.value.should eq(11)
      result.bind(&.even?).should be_false
    end
  end

  describe ".or" do
    it "does not use block in or calls" do
      right.or { |x| x.should be_false}.should eq(right)
    end

    it "does not use args passed in" do
      right.or(false).should eq(right)
    end
  end

  describe ".value" do
    it "returns the value that is wrapped" do
      right.value.should eq(5)
    end
  end

  describe ".right?" do
    it "returns true" do
      right.right?.should be_true
    end
  end

  describe ".left?" do
    it "returns false" do
      right.left?.should be_false
    end
  end

  describe ".to_s" do
    it "returns a string representation of Right" do
      right.to_s.should eq("Right(5)")
    end
  end
end

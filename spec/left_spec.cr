require "./spec_helper"

describe CrystalMonads::Either::Left do
  left = CrystalMonads::Either::Left.new(5)

  describe "#bind" do
    it "returns self when given a block with args" do
      left.bind(:foo) { |value, c| false.should be_true }.should eq(left)
    end

    it "returns self when given a proc with args" do
      proc = -> (value : Int32, c : Symbol) do
        false.should be_true
      end

      left.bind(proc, :foo).should eq(left)
    end

    it "returns self when given a block" do
      left.bind { |x| x + 5 }.should eq(left)
    end
  end

  describe "#fmap" do
    it "returns self when given a block" do
      result = left.fmap { |x| x + 5 }
      result.should be_a CrystalMonads::Either::Left(Int32)
      result.should eq(left)
    end

    it "returns self when given a block with extra args" do
      result = left.fmap(:foo) do |value, c|
        true
      end

      result.should be_a CrystalMonads::Either::Left(Int32)
      result.should eq(left)
    end

    it "returns self when given a proc" do
      proc = -> (value : Int32, c : Symbol) do
        true
      end

      result = left.fmap(proc, :foo)
      result.should be_a CrystalMonads::Either::Left(Int32)
      result.should eq(left)
    end

    it "can be chained but always returns self" do
      result = left.fmap(&.succ).fmap { |x| x + 5 }
      result.should be_a CrystalMonads::Either::Left(Int32)
      result.should eq(left)
      result.bind(&.even?).should eq(left)
    end
  end

  describe "#or" do
    it "uses the block" do
      left.or { |x| x + 5 }.should eq(10)
    end

    it "passes extra arguments to the block" do
      left.or(:foo, :bar) do |value, a, b|
        value.as(Int32).should eq(5)
        a.as(Symbol).should eq(:foo)
        b.as(Symbol).should eq(:bar)
        false
      end.should be_false
    end
  end

  describe "#value" do
    it "returns the value that is wrapped" do
      left.value.should eq(5)
    end
  end

  describe "#right?" do
    it "returns false" do
      left.right?.should be_false
    end
  end

  describe ".left?" do
    it "returns true" do
      left.left?.should be_true
    end
  end

  describe ".to_s" do
    it "returns a string representation of Left" do
      left.to_s.should eq("Left(5)")
    end
  end
end

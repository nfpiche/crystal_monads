require "./spec_helper"

describe CrystalMonads::Either::Left do
  left = CrystalMonads::Either::Left.new(5)

  describe "#bind" do
    it "returns self when given a block with arguments" do
      left.bind(:foo) { false.should be_true }.should eq(left)
    end

    it "returns self when given a proc" do
      proc = -> () do
        false.should be_true
      end

      left.bind(proc).should eq(left)
    end

    it "returns self when given a proc with arguments" do
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

    it "returns self when given a block with extra arguments" do
      result = left.fmap(:foo) do |value, c|
        true
      end

      result.should be_a CrystalMonads::Either::Left(Int32)
      result.should eq(left)
    end

    it "returns self when given a proc" do
      proc = -> () { true }

      result = left.fmap(proc, :foo)
      result.should be_a CrystalMonads::Either::Left(Int32)
      result.should eq(left)
    end

    it "returns self when given a proc with arguments" do
      proc = -> (value : Int32, c : Symbol) { true }

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

    it "uses the proc" do
      left.or(&.odd?).should be_true
    end

    it "passes extra arguments to the block" do
      left.or(:foo, :bar) do |value, a, b|
        value.as(Int32).should eq(5)
        a.as(Symbol).should eq(:foo)
        b.as(Symbol).should eq(:bar)
        false
      end.should be_false
    end

    it "passes extra arguments to proc" do
      proc = -> (value : Int32, c : Symbol) do
        value.should eq(5)
        c.should eq(:foo)
        true
      end

      left.or(proc, :foo).should be_true
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

  describe "#left?" do
    it "returns true" do
      left.left?.should be_true
    end
  end

  describe "#to_s" do
    it "returns a string representation of Left" do
      left.to_s.should eq("Left(5)")
    end
  end

  describe "#to_maybe" do
    it "returns a None" do
      maybe = left.to_maybe

      maybe.should be_a CrystalMonads::Maybe::None
      maybe.value.should be_nil
    end
  end
end

require "./spec_helper"

describe CrystalMonads do
  some_maybe = CrystalMonads::Maybe.build(5)
  none_maybe = CrystalMonads::Maybe.build(nil)

  describe CrystalMonads::Maybe do
    describe "#build" do
      it "returns expected type" do
        some_maybe.should be_a CrystalMonads::Some(Int32)
        none_maybe.should be_a CrystalMonads::None
      end
    end
  end

  describe CrystalMonads::Some do
    describe "#bind" do
    end
  end

  describe CrystalMonads::None do
    describe "#bind" do
      it "returns a None object when given a Proc" do
        proc = -> () { false.should be_true }
        none_maybe.bind(proc).should eq(none_maybe)
      end

      it "returns a None object when given a Proc with args" do
        proc = -> (c : Symbol) { c.should be_a Int32 }
        none_maybe.bind(proc, :foo).should eq(none_maybe)
      end

      it "returns a None object when given a block" do
        none_maybe.bind { false.should be_true }.should eq(none_maybe)
      end

      it "returns a None object when given a block with args" do
        none_maybe.bind(:foo) { |c| c.as(Symbol).should be_a Int32 }.should eq(none_maybe)
      end
    end
  end
end

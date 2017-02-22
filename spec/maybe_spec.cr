require "./spec_helper"

describe CrystalMonads do
  some_maybe = CrystalMonads::Maybe.lift(5)
  none_maybe = CrystalMonads::Maybe.lift(nil)

  describe CrystalMonads::Maybe do
    describe "#lift" do
      it "returns expected type" do
        some_maybe.should be_a CrystalMonads::Maybe::Some(Int32)
        none_maybe.should be_a CrystalMonads::Maybe::None
      end
    end
  end

  describe CrystalMonads::Maybe::Some do
    describe "#bind" do
      it "returns the value applied to the Proc" do
        some_maybe.bind(&.even?).should be_false
      end

      it "calls the Proc with the value and all extra arguments" do
        proc = -> (value : Int32, c : Int32, d : Bool) do
          value > c && d
        end

        some_maybe.bind(proc, 1, true).should be_true
      end

      it "uses the value in the block" do
        some_maybe.bind { |value| value.odd? }.should be_true
      end

      it "uses the value and extra arguments in block" do
        result = some_maybe.bind(5, 6) do |value, c, d|
          value == c.as(Int32) && d.as(Int32) > c
        end

        result.should be_true
      end
    end

    describe "#fmap" do
      proc = -> (value : Int32) do
        value > 4 ? 6 : nil
      end

      arg_proc = -> (value : Int32, c : Bool) do
        true if value == 5 && c
      end

      context "a proc with no arguments" do
        it "returns Some when proc evaluates to non-nil value" do
          result = some_maybe.fmap(proc)

          result.should be_a CrystalMonads::Maybe::Some(Int32 | Nil)
          result.value.should eq(6)
        end

        it "returns a None when proc evaluates to nil" do
          some_to_none_maybe = CrystalMonads::Maybe.lift(1)
          result = some_to_none_maybe.fmap(proc)

          result.should be_a CrystalMonads::Maybe::None
          result.value.should be_nil
        end
      end

      context "a proc with arguments" do
        it "returns Some when proc evaluates to non-nil value" do
          result = some_maybe.fmap(arg_proc, true)

          result.should be_a CrystalMonads::Maybe::Some(Bool | Nil)
          result.value.should be_true
        end

        it "returns a None when proc evaluates to nil" do
          result = some_maybe.fmap(arg_proc, false)

          result.should be_a CrystalMonads::Maybe::None
          result.value.should be_nil
        end
      end

      context "a block with arguments" do
        it "returns Some when block evaluates to non-nil value" do
          result = some_maybe.fmap(true) { |value, c| true if c }

          result.should be_a CrystalMonads::Maybe::Some(Bool | Nil)
          result.value.should be_true
        end

        it "returns a None when block evaluates to nil" do
          result = some_maybe.fmap(false) { |value, c| true if c }

          result.should be_a CrystalMonads::Maybe::None
          result.value.should be_nil
        end
      end

      context "a block with no arguments" do
        it "returns Some when block evaluates to non-nil value" do
          result = some_maybe.fmap { |value| value > 4 }

          result.should be_a CrystalMonads::Maybe::Some(Bool)
          result.value.should be_true
        end

        it "returns a None when block evaluates to nil" do
          result = some_maybe.fmap { nil }

          result.should be_a CrystalMonads::Maybe::None
          result.value.should be_nil
        end
      end
    end

    describe "#or" do
      it "returns self object when given a Proc" do
        proc = -> () { false.should be_true }
        some_maybe.or(proc).should eq(some_maybe)
      end

      it "returns self object when given a Proc with arguments" do
        proc = -> (c : Symbol) { c.should be_a Int32 }
        some_maybe.or(proc, :foo).should eq(some_maybe)
      end

      it "returns self object when given a block" do
        some_maybe.or { false.should be_true }.should eq(some_maybe)
      end

      it "returns self object when given a block with arguments" do
        some_maybe.or(:foo) { |c| c.as(Symbol).should be_a Int32 }.should eq(some_maybe)
      end
    end

    describe "#to_s" do
      it "returns a String representations of Some" do
        some_maybe.to_s.should eq("Some(5)")
      end
    end
  end

  describe CrystalMonads::Maybe::None do
    describe "#bind" do
      it "returns self object when given a Proc" do
        proc = -> () { false.should be_true }
        none_maybe.bind(proc).should eq(none_maybe)
      end

      it "returns self object when given a Proc with arguments" do
        proc = -> (c : Symbol) { c.should be_a Int32 }
        none_maybe.bind(proc, :foo).should eq(none_maybe)
      end

      it "returns self object when given a block" do
        none_maybe.bind { false.should be_true }.should eq(none_maybe)
      end

      it "returns self object when given a block with arguments" do
        none_maybe.bind(:foo) { |c| c.as(Symbol).should be_a Int32 }.should eq(none_maybe)
      end
    end

    describe "#fmap" do
      it "returns self object when given a Proc" do
        proc = -> () { false.should be_true }
        none_maybe.fmap(proc).should eq(none_maybe)
      end

      it "returns self object when given a Proc with arguments" do
        proc = -> (c : Symbol) { c.should be_a Int32 }
        none_maybe.fmap(proc, :foo).should eq(none_maybe)
      end

      it "returns self object when given a block" do
        none_maybe.fmap { false.should be_true }.should eq(none_maybe)
      end

      it "returns self object when given a block with arguments" do
        none_maybe.fmap(:foo) { |c| c.as(Symbol).should be_a Int32 }.should eq(none_maybe)
      end
    end

    describe "#or" do
      it "returns the value the proc evaluates to" do
        proc = -> () { true }
        none_maybe.or(proc).should be_true
      end

      it "returns the value the proc with arguments evaluates to" do
        proc = -> (a : Int32, b : Int32) { a > b }
        none_maybe.or(proc, 3, 2).should be_true
      end

      it "returns the value the block evalutes to" do
        none_maybe.or { true }.should be_true
      end

      it "returns self object when given a block with arguments" do
        none_maybe.or(3, 2) { |a, b| a > b}.should be_true
      end
    end

    describe "#to_s" do
      it "returns a String representations of None" do
        none_maybe.to_s.should eq("None()")
      end
    end
  end
end

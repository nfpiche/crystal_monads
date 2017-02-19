require "./crystal-monads/*"

module CrystalMonads
  def self.foo
    x = CrystalMonads::Either::Mixin.right([1, 2, 3])
    x.bind { |arr| arr.map(&.succ) }
  end
end

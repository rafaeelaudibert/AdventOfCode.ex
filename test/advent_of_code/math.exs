defmodule AdventOfCode.MathTest do
  use ExUnit.Case

  test "extended_gcd -> Same value" do
    result = Math.extended_gcd(3, 3)
    assert result == {3, 0}
  end

  test "extended_gcd -> Multiple of the other" do
    result = Math.extended_gcd(3, 6)
    assert result == {3, 1}
  end

  test "extended_gcd -> Primes" do
    result = Math.extended_gcd(7, 11)
    assert result == {1, -3}
  end

  test "modular_inverse -> not coprimes" do
    assert_raise RuntimeError, "2 and 4 are not coprimes", fn -> Math.modular_inverse(2, 4) end
  end

  test "modular_inverse -> primes" do
    result = Math.modular_inverse(307, 443)
    assert result == 114
  end

  test "modular_inverse -> coprimes" do
    result = Math.modular_inverse(4, 9)
    assert result == 7
  end

  test "chinese_remainder" do
    result =
      Math.chinese_remainder(
        [23, 37, 431, 13, 17, 19, 409, 41, 29],
        [0, 20, 408, 3, 14, 15, 355, 18, 4]
      )

    assert result == 402_251_700_208_309
  end
end

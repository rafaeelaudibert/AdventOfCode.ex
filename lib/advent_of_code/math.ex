defmodule Math do
  @spec extended_gcd(integer, integer) :: {integer, integer}
  def extended_gcd(a, b) do
    {last_remainder, last_x} = extended_gcd(abs(a), abs(b), 1, 0, 0, 1)
    {last_remainder, last_x * if(a < 0, do: -1, else: 1)}
  end

  defp extended_gcd(last_remainder, 0, last_x, _, _, _), do: {last_remainder, last_x}

  defp extended_gcd(last_remainder, remainder, last_x, x, last_y, y) do
    quotient = div(last_remainder, remainder)
    remainder2 = rem(last_remainder, remainder)
    extended_gcd(remainder, remainder2, x, last_x - quotient * x, y, last_y - quotient * y)
  end

  @spec modular_inverse(integer, integer) :: integer
  def modular_inverse(e, et) do
    {g, x} = extended_gcd(e, et)
    if g != 1, do: raise("#{e} and #{et} are not coprimes")
    rem(x + et, et)
  end

  @spec chinese_remainder([integer], [integer]) :: integer
  def chinese_remainder(mods, remainders) do
    max = Enum.reduce(mods, &*/2)

    Enum.zip(mods, remainders)
    |> Enum.reduce(0, fn {n_i, a_i}, acc ->
      p = div(max, n_i)
      acc + a_i * modular_inverse(p, n_i) * p
    end)
    |> rem(max)
  end
end

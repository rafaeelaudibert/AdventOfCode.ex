import AdventOfCode.Helpers.Input

defmodule AdventOfCode.Day25 do
  @spec part1(String.t()) :: non_neg_integer()
  def part1(filename) do
    modulo = 20_201_227
    subject_number = 7

    [card_public, door_public] = read_integers(filename)

    loop_size_card =
      Stream.iterate(1, fn value -> rem(value * subject_number, modulo) end)
      |> Enum.take_while(fn val -> val != card_public end)
      |> length()

    Stream.iterate(1, fn value -> rem(value * door_public, modulo) end)
    |> Enum.take(loop_size_card + 1)
    |> List.last()
  end

  # Day 25 has no part 2
  @spec part2(String.t()) :: non_neg_integer()
  def part2(_), do: 2020
end

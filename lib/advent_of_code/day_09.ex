import AdventOfCode.Helpers.Input

defmodule AdventOfCode.Day09 do
  # There are edge cases when data or rest ends, but this can't occur to have a satisfactory
  # solution, so we don't treat them
  @spec find_list_of_sum([non_neg_integer()], non_neg_integer(), non_neg_integer(), [
          non_neg_integer()
        ]) ::
          [non_neg_integer()]
  defp find_list_of_sum(
         [head_data | tail_data] = data,
         curr_sum,
         target,
         [head_rest | tail_rest] = rest
       ) do
    cond do
      curr_sum == target ->
        data

      curr_sum < target ->
        find_list_of_sum(data ++ [head_rest], curr_sum + head_rest, target, tail_rest)

      curr_sum > target ->
        find_list_of_sum(tail_data, curr_sum - head_data, target, rest)
    end
  end

  @spec find_multiplication(non_neg_integer(), non_neg_integer(), [non_neg_integer()]) ::
          boolean() | {non_neg_integer(), non_neg_integer()}
  defp find_multiplication(_, _, []), do: false

  defp find_multiplication(val, target, [head | tail]) do
    if val + head == target,
      do: {val, head},
      else: find_multiplication(val, target, tail)
  end

  @spec part1(String.t()) :: non_neg_integer()
  def part1(filename) do
    input = read_integers(filename)

    Stream.iterate(25, &(&1 + 1))
    |> Enum.find_value(fn idx ->
      vals = Enum.drop(input, idx - 25) |> Enum.take(25)
      current = Enum.at(input, idx)

      if vals |> Enum.find_value(&find_multiplication(&1, current, vals)) == nil,
        do: current
    end)
  end

  @spec part2(String.t()) :: non_neg_integer()
  def part2(filename) do
    # invalid_number = part1(filename) # but we can just hardcode it to make it faster
    invalid_number = 50_047_984

    [head_input | tail_input] = read_integers(filename)

    find_list_of_sum([head_input], head_input, invalid_number, tail_input)
    |> Enum.min_max()
    |> Enum.sum()
  end
end

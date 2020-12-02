import AdventOfCode.Helpers.Input

defmodule AdventOfCode.Day01 do
  defp find_multiplication(val, list), do: find_multiplication(val, 2020, list)
  defp find_multiplication(_, _, []), do: false
  defp find_multiplication(val, target, [head|tail]) do
      if val + head == target,
        do: val * head,
        else: find_multiplication(val, target, tail)
  end

  @spec part1(String.t()) :: integer
  def part1(test_filename) do
    input = read_integers(test_filename)
    Enum.find_value(input, &(find_multiplication(&1, input)) )
  end

  @spec part2(String.t()) :: integer
  def part2(test_filename) do
    input = read_integers(test_filename)
    Enum.find_value(input, fn(x) -> 
      case Enum.find_value(input, &(find_multiplication(&1, 2020 - x, input))) do
        nil -> nil
        val -> val * x
      end      
    end )
  end
end

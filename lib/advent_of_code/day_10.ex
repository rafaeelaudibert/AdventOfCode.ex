import AdventOfCode.Helpers.Input

defmodule AdventOfCode.Day10 do
  # This will make it count twice at the end,
  # but we just need to divide by 2 in the driver function
  @spec possibilities(non_neg_integer(), [non_neg_integer()], %{}) :: {non_neg_integer, %{}}
  defp possibilities(_, [], dp), do: {1, dp}

  defp possibilities(curr, [head_list | tail_list], dp) do
    idx_hash = {curr, head_list}

    dp =
      if dp[idx_hash] == nil do
        {result, dp} =
          if head_list - curr <= 3 do
            # If can use this value, try with and without it, passing the DP
            {x1, dp} = possibilities(head_list, tail_list, dp)
            {x2, dp} = possibilities(curr, tail_list, dp)

            {x1 + x2, dp}
          else
            # If can't use, we don't need to test the others
            {0, dp}
          end

        Map.put(
          dp,
          idx_hash,
          result
        )
      else
        dp
      end

    {dp[idx_hash], dp}
  end

  @spec part1(String.t()) :: non_neg_integer()
  def part1(filename) do
    read_integers(filename)
    |> Enum.sort()
    |> Enum.reduce({0, 0, 1}, fn curr, {before, diff_1, diff_3} ->
      case curr - before do
        1 -> {curr, diff_1 + 1, diff_3}
        3 -> {curr, diff_1, diff_3 + 1}
        _ -> {curr, diff_1, diff_3}
      end
    end)
    |> (fn {_before, diff_1, diff_3} -> diff_1 * diff_3 end).()
  end

  @spec part2(String.t()) :: non_neg_integer()
  def part2(filename) do
    read_integers(filename)
    |> Enum.sort()
    |> (fn input -> possibilities(0, input, %{}) end).()
    |> (fn {result, _} -> div(result, 2) end).()
  end
end

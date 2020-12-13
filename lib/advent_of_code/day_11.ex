import AdventOfCode.Helpers.Input

defmodule AdventOfCode.Day11 do
  @type pattern :: [[String.t()]]
  @type application_func :: (pattern(), non_neg_integer(), non_neg_integer() -> String.t())

  @spec if_neg_number(integer(), integer()) :: integer()
  defp if_neg_number(val, number \\ 1_000_000_000), do: if(val < 0, do: number, else: val)

  @spec apply_rule_to_idx_1(pattern(), non_neg_integer(), non_neg_integer()) :: String.t()
  defp apply_rule_to_idx_1(pattern, idx_out, idx_inside) do
    value = Enum.at(pattern, idx_out) |> Enum.at(idx_inside)

    neighbours =
      [{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}]
      |> Enum.map(fn {dout, dinside} ->
        Enum.at(pattern, if_neg_number(idx_out + dout), [])
        |> Enum.at(if_neg_number(idx_inside + dinside))
      end)

    count_neighbours = neighbours |> Enum.count(fn val -> val == "#" end)

    case value do
      "L" when count_neighbours == 0 ->
        "#"

      "#" when count_neighbours >= 4 ->
        "L"

      x ->
        x
    end
  end

  @spec apply_rule_to_idx_2(pattern(), non_neg_integer(), non_neg_integer()) :: String.t()
  defp apply_rule_to_idx_2(pattern, idx_out, idx_inside) do
    value = Enum.at(pattern, idx_out) |> Enum.at(idx_inside)

    neighbours =
      [{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}]
      |> Enum.map(fn {dout, din} ->
        Stream.iterate({dout, din}, fn {dout_, din_} -> {dout + dout_, din + din_} end)
      end)
      |> Enum.map(fn stream ->
        Enum.find_value(stream, fn {dout, dinside} ->
          Enum.at(pattern, if_neg_number(idx_out + dout), [])
          |> Enum.at(if_neg_number(idx_inside + dinside))
          |> (fn val ->
                case val do
                  "L" -> "L"
                  "#" -> "#"
                  # This is the case we reached the border, so it counts as free
                  nil -> "@"
                  _ -> nil
                end
              end).()
        end)
      end)

    count_neighbours = neighbours |> Enum.count(fn val -> val == "#" end)

    case value do
      "L" when count_neighbours == 0 ->
        "#"

      "#" when count_neighbours >= 5 ->
        "L"

      x ->
        x
    end
  end

  @spec apply_rules(pattern(), application_func()) :: pattern()
  defp apply_rules(pattern, application_rule) do
    Enum.with_index(pattern)
    |> Enum.map(fn {line, idx_out} ->
      Enum.with_index(line)
      |> Enum.map(fn {_, idx_inside} -> application_rule.(pattern, idx_out, idx_inside) end)
    end)
  end

  @spec apply_rules_until_stop(pattern(), application_func(), MapSet.t()) :: String.t()
  defp apply_rules_until_stop(pattern, application_rule, used \\ MapSet.new()) do
    stringified = Enum.map(pattern, &Enum.join/1) |> Enum.join("\n")

    if MapSet.member?(used, stringified) do
      stringified
    else
      used = MapSet.put(used, stringified)
      pattern = apply_rules(pattern, application_rule)
      apply_rules_until_stop(pattern, application_rule, used)
    end
  end

  @spec part1(String.t()) :: non_neg_integer()
  def part1(test_filename) do
    read_lines(test_filename)
    |> Enum.map(&(&1 |> String.graphemes()))
    |> apply_rules_until_stop(&apply_rule_to_idx_1/3)
    |> String.graphemes()
    |> Enum.count(&(&1 == "#"))
  end

  @spec part2(String.t()) :: non_neg_integer()
  def part2(test_filename) do
    read_lines(test_filename)
    |> Enum.map(&(&1 |> String.graphemes()))
    |> apply_rules_until_stop(&apply_rule_to_idx_2/3)
    |> String.graphemes()
    |> Enum.count(&(&1 == "#"))
  end
end

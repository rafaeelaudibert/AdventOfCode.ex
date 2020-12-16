import AdventOfCode.Helpers.Input

defmodule AdventOfCode.Day16 do
  @type rule ::
          {String.t(), {non_neg_integer(), non_neg_integer()},
           {non_neg_integer(), non_neg_integer()}}

  @spec parse_rules([String.t()]) :: [rule]
  defp parse_rules(rules) do
    Enum.map(rules, fn rule ->
      [name, options] = String.split(rule, ": ")

      [low1, high1, low2, high2] =
        Regex.scan(~r/[0-9]+/, options) |> Enum.flat_map(& &1) |> Enum.map(&String.to_integer/1)

      {name, {low1, high1}, {low2, high2}}
    end)
  end

  @spec valid_for_any_rule(non_neg_integer(), [rule]) :: boolean()
  defp valid_for_any_rule(value, rules) do
    Enum.any?(rules, fn {_, {low1, high1}, {low2, high2}} ->
      (value >= low1 and value <= high1) or (value >= low2 and value <= high2)
    end)
  end

  @spec get_possible_rules([non_neg_integer()], [rule]) :: [rule]
  defp get_possible_rules(values, rules) do
    Enum.filter(rules, fn {_, {low1, high1}, {low2, high2}} ->
      Enum.all?(values, &((&1 >= low1 and &1 <= high1) or (&1 >= low2 and &1 <= high2)))
    end)
  end

  @spec part1(String.t()) :: non_neg_integer()
  def part1(filename) do
    [rules, _, [_ | other_tickets]] = read_chunked_lines(filename)

    rules = parse_rules(rules)

    Enum.flat_map(other_tickets, fn tickets ->
      tickets |> String.split(",") |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.filter(fn other_ticket ->
      not valid_for_any_rule(other_ticket, rules)
    end)
    |> Enum.sum()
  end

  @spec part2(String.t()) :: non_neg_integer()
  def part2(filename) do
    [rules, [_ | [my_tickets | []]], [_ | other_tickets]] = read_chunked_lines(filename)

    rules = parse_rules(rules)

    other_tickets =
      Enum.map(other_tickets, fn tickets ->
        tickets |> String.split(",") |> Enum.map(&String.to_integer/1)
      end)
      |> Enum.filter(fn tickets -> Enum.all?(tickets, &valid_for_any_rule(&1, rules)) end)

    possible_rules =
      Enum.zip(other_tickets)
      |> Enum.map(
        &(&1
          |> Tuple.to_list()
          |> get_possible_rules(rules)
          |> Enum.map(fn {name, _, _} -> name end))
      )

    departure_indexes =
      Enum.with_index(possible_rules)
      |> Enum.sort_by(fn {rules, _} -> length(rules) end, &<=/2)
      |> Enum.reduce([], fn {rules, idx}, list ->
        rule = Enum.find(rules, &(not Enum.any?(list, fn {val, _} -> &1 == val end)))
        list ++ [{rule, idx}]
      end)
      |> Enum.filter(fn {name, _} -> String.contains?(name, "departure") end)
      |> Enum.map(fn {_, idx} -> idx end)
      |> MapSet.new()

    String.split(my_tickets, ",")
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index()
    |> Enum.reduce(1, fn {ticket, idx}, acc ->
      if MapSet.member?(departure_indexes, idx), do: ticket * acc, else: acc
    end)
  end
end

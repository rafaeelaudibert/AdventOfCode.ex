import AdventOfCode.Helpers.Input

defmodule AdventOfCode.Day19 do
  @spec parse_lines_to_rules([String.t()]) :: %{}
  defp parse_lines_to_rules(lines_of_rules) do
    Enum.map(lines_of_rules, fn line ->
      [number, rule] = String.split(line, ": ", parts: 2)
      {String.to_integer(number), rule}
    end)
    |> Enum.into(%{})
  end

  @spec parse_lines_to_rules(String.t()) :: [[non_neg_integer()]]
  defp rules_to_list(rule) do
    String.split(rule, " | ")
    |> Enum.map(fn follow_rules ->
      String.split(follow_rules, " ") |> Enum.map(&String.to_integer/1)
    end)
  end

  @spec expand_rules(%{}, non_neg_integer(), %{}) :: {non_neg_integer(), %{}}
  defp expand_rules(rules, idx, memory \\ %{}) do
    if memory[idx] != nil do
      {memory[idx], memory}
    else
      curr_rule = rules[idx]

      {result, memory} =
        if Regex.match?(~r/\"[a-z]\"/, curr_rule) do
          {[String.graphemes(curr_rule) |> Enum.at(1)], memory}
        else
          rules_for_curr = rules_to_list(curr_rule)

          Enum.reduce(rules_for_curr, {[], memory}, fn list, {past_rules, memory} ->
            {generated, memory} =
              Enum.reduce(list, {[""], memory}, fn rule_to_follow, {curr_words, memory} ->
                {generated, memory} = expand_rules(rules, rule_to_follow, memory)

                {
                  Enum.flat_map(curr_words, fn word -> Enum.map(generated, &(word <> &1)) end),
                  memory
                }
              end)

            {past_rules ++ generated, memory}
          end)
        end

      {result, Map.put(memory, idx, result)}
    end
  end

  @spec consume(String.t(), %{}, non_neg_integer()) :: {String.t(), non_neg_integer()}
  defp consume(message, rules, count \\ 0) do
    rule = Enum.find(rules, &String.starts_with?(message, &1))

    if rule == nil do
      {message, count}
    else
      rest = String.slice(message, byte_size(rule), byte_size(message))
      consume(rest, rules, count + 1)
    end
  end

  @spec part1(String.t()) :: non_neg_integer()
  def part1(filename) do
    [lines_of_rules, messages] = read_chunked_lines(filename)
    rules = parse_lines_to_rules(lines_of_rules)

    # We can do the following, because if we expand the 0 rule we have 42 42 31
    # so we only need 42 and 31 and hardcode its unions
    [rules_42, rules_31] =
      Enum.map([42, 31], &(expand_rules(rules, &1) |> elem(0) |> MapSet.new()))

    Enum.count(messages, fn message ->
      {rest_message, count_42} = consume(message, rules_42)
      {rest_message, count_31} = consume(rest_message, rules_31)

      count_42 == 2 and count_31 == 1 and rest_message == ""
    end)
  end

  @spec part2(String.t()) :: non_neg_integer()
  def part2(filename) do
    [lines_of_rules, messages] = read_chunked_lines(filename)
    rules = parse_lines_to_rules(lines_of_rules)

    # We can do the following, because if we expand the 0 rule we have
    # 42 42+ 31+, this is, n rules 42 followed by m rules 31, where n and m are not 0
    # and m needs to be less than n
    # this way, we only need to compute 42 and 31 and hardcode its unions
    [rules_42, rules_31] =
      Enum.map([42, 31], &(expand_rules(rules, &1) |> elem(0) |> MapSet.new()))

    Enum.count(messages, fn message ->
      {rest_message, count_42} = consume(message, rules_42)
      {rest_message, count_31} = consume(rest_message, rules_31)

      count_42 >= 2 and count_31 > 0 and count_31 < count_42 and rest_message == ""
    end)
  end
end

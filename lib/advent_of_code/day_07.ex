import AdventOfCode.Helpers.Input

defmodule AdventOfCode.Day07 do
  @type bag :: [{integer(), String.t()}]
  @type graph :: %{String.t() => [String.t()]}

  @spec parse_bags_string(String.t()) :: {String.t(), [bag()]}
  defp parse_bags_string(bags_string) do
    [_ | [bag_color, other_colors]] = Regex.run(~r/(.+) bags contain (.+)\./U, bags_string)

    other_colors =
      String.split(other_colors, ", ")
      |> Enum.map(fn color_string ->
        String.replace(color_string, ~r/ bags?/, "")
        |> String.split(" ", parts: 2)
        |> List.to_tuple()
      end)
      |> Enum.filter(fn {number, _} -> number != "no" end)
      |> Enum.map(fn {number, text} -> {Integer.parse(number) |> elem(0), text} end)

    {bag_color, other_colors}
  end

  @spec graph_size(graph, String.t()) :: non_neg_integer()
  defp graph_size(graph, start) do
    Stream.unfold([{0, start}], fn
      [] -> nil
      [{_, head} | tail] -> {head, tail ++ (graph[head] || [])}
    end)
    |> Enum.uniq()
    |> length()
    |> (&(&1 - 1)).()
  end

  @spec reverse_graph(graph()) :: graph()
  defp reverse_graph(graph) do
    graph
    |> Enum.reduce(%{}, fn {name, items}, graph ->
      Enum.reduce(items, graph, fn {count, edge}, graph ->
        Map.update(graph, edge, [{count, name}], &[{count, name} | &1])
      end)
    end)
  end

  @spec count_bags(graph, String.t()) :: non_neg_integer()
  defp count_bags(graph, start) do
    Enum.reduce(graph[start] || [], 0, fn {count, name}, acc ->
      acc + count + count * count_bags(graph, name)
    end)
  end

  @spec part1(String.t()) :: non_neg_integer()
  def part1(filename) do
    read_lines(filename)
    |> Enum.map(&parse_bags_string/1)
    |> Map.new()
    |> reverse_graph()
    |> graph_size("shiny gold")
  end

  @spec part2(String.t()) :: non_neg_integer()
  def part2(filename) do
    read_lines(filename)
    |> Enum.map(&parse_bags_string/1)
    |> Map.new()
    |> count_bags("shiny gold")
  end
end

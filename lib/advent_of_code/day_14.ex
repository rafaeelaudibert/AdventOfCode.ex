import AdventOfCode.Helpers.Input

defmodule AdventOfCode.Day14 do
  @spec parse_line(String.t()) :: {:mask | :value, integer() | nil, String.t() | integer()}
  defp parse_line(line) do
    [start, _, value] = String.split(line, " ")

    if start === "mask" do
      {:mask, nil, value}
    else
      address = Regex.run(~r/([0-9])+/, start) |> Enum.at(0) |> Integer.parse() |> elem(0)
      value = Integer.parse(value) |> elem(0)
      {:value, address, value}
    end
  end

  @spec find_addresses([String.t()], [String.t()]) :: [String.t()]
  defp find_addresses([], []), do: [""]

  defp find_addresses([cur_address | tail_address], [cur_mask | tail_mask]) do
    children = find_addresses(tail_address, tail_mask)

    cond do
      cur_mask == "0" -> Enum.map(children, &(cur_address <> &1))
      cur_mask == "1" -> Enum.map(children, &("1" <> &1))
      cur_mask == "X" -> Enum.flat_map(children, &["1" <> &1, "0" <> &1])
    end
  end

  @spec solve_part_1(String.t(), {String.t(), Map.t()}) :: {String.t(), Map.t()}
  defp solve_part_1(line, {curr_mask, memory}) do
    {new_mask, address, value} =
      case parse_line(line) do
        {:mask, _, mask} -> {mask, nil, nil}
        {:value, address, value} -> {curr_mask, address, value}
      end

    if address == nil do
      {new_mask, memory}
    else
      # Update the memory, according to the value but masked
      str_value = Integer.to_string(value, 2) |> String.pad_leading(36, "0")

      masked_value =
        Enum.zip(String.graphemes(str_value), String.graphemes(new_mask))
        |> Enum.map(fn {char, mask} -> if mask == "X", do: char, else: mask end)
        |> Enum.join()
        |> Integer.parse(2)
        |> elem(0)

      memory = Map.put(memory, address, masked_value)
      {new_mask, memory}
    end
  end

  @spec solve_part_2(String.t(), {String.t(), Map.t()}) :: {String.t(), Map.t()}
  defp solve_part_2(line, {curr_mask, memory}) do
    {new_mask, address, value} =
      case parse_line(line) do
        {:mask, _, mask} -> {mask, nil, nil}
        {:value, address, value} -> {curr_mask, address, value}
      end

    if address == nil do
      {new_mask, memory}
    else
      # Find every address to add to the memory
      str_address = Integer.to_string(address, 2) |> String.pad_leading(36, "0")

      addresses =
        find_addresses(String.graphemes(str_address), String.graphemes(new_mask))
        |> Enum.map(fn address -> Integer.parse(address, 2) |> elem(0) end)

      memory = Enum.reduce(addresses, memory, &Map.put(&2, &1, value))
      {new_mask, memory}
    end
  end

  @spec part1(String.t()) :: non_neg_integer()
  def part1(test_filename) do
    read_lines(test_filename)
    |> Enum.reduce({String.pad_leading("", 36, "X"), %{}}, &solve_part_1/2)
    |> (fn {_, map} -> Map.values(map) |> Enum.reduce(&+/2) end).()
  end

  @spec part2(String.t()) :: non_neg_integer()
  def part2(test_filename) do
    read_lines(test_filename)
    |> Enum.reduce({String.pad_leading("", 36, "X"), %{}}, &solve_part_2/2)
    |> (fn {_, map} -> Map.values(map) |> Enum.reduce(&+/2) end).()
  end
end

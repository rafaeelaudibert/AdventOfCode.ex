import AdventOfCode.Helpers.Input

defmodule AdventOfCode.Day04 do
  @spec validate_pattern(String.t()) :: boolean()
  defp validate_pattern(option) do
    case String.split(option, ":") do
      ["cid", _] ->
        true

      ["byr", byr] ->
        String.to_integer(byr) |> (fn x -> x >= 1920 and x <= 2002 end).()

      ["iyr", iyr] ->
        String.to_integer(iyr) |> (fn x -> x >= 2010 and x <= 2020 end).()

      ["eyr", eyr] ->
        String.to_integer(eyr) |> (fn x -> x >= 2020 and x <= 2030 end).()

      ["hgt", hgt] ->
        Integer.parse(hgt)
        |> (fn {x, unit} ->
              if unit == "cm",
                do: x >= 150 and x <= 193,
                else: if(unit == "in", do: x >= 59 and x <= 76, else: false)
            end).()

      ["hcl", hcl] ->
        Regex.match?(~r/#[0-9a-f]{6}/, hcl)

      ["ecl", ecl] ->
        ecl in ~w[amb blu brn gry grn hzl oth]

      ["pid", pid] ->
        Regex.match?(~r/^[0-9]{9}$/, pid)

      _ ->
        false
    end
  end

  @spec parse_input([String.t()]) :: [String.t()]
  defp parse_input(input) do
    input |> Enum.map(&(&1 |> Enum.join(" ") |> String.split(" ")))
  end

  @spec build_set([String.t()]) :: MapSet.t()
  defp build_set(input) do
    Enum.map(input, fn val -> String.split(val, ":") |> List.first() end)
    |> MapSet.new()
  end

  @spec part1(String.t()) :: non_neg_integer()
  def part1(filename) do
    keys = MapSet.new(~w[byr iyr eyr hgt hcl ecl pid])

    read_chunked_lines(filename)
    |> parse_input()
    |> Enum.map(&build_set(&1))
    |> Enum.count(&MapSet.subset?(keys, &1))
  end

  @spec part2(String.t()) :: non_neg_integer()
  def part2(filename) do
    keys = MapSet.new(~w[byr iyr eyr hgt hcl ecl pid])

    read_chunked_lines(filename)
    |> parse_input()
    |> Enum.map(fn list ->
      {
        build_set(list),
        Enum.map(list, &validate_pattern/1) |> Enum.all?()
      }
    end)
    |> Enum.count(fn {set, valid_keys} -> MapSet.subset?(keys, set) and valid_keys end)
  end
end

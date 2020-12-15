import AdventOfCode.Helpers.Input

defmodule AdventOfCode.Day04 do
  @spec validate_pattern(String.t()) :: boolean()
  defp validate_pattern(option) do
    case String.split(option, ":") do
      ["cid", _] ->
        true

      ["byr", byr] ->
        Integer.parse(byr) |> (fn {x, rest} -> x >= 1920 and x <= 2002 and rest == "" end).()

      ["iyr", iyr] ->
        Integer.parse(iyr) |> (fn {x, rest} -> x >= 2010 and x <= 2020 and rest == "" end).()

      ["eyr", eyr] ->
        Integer.parse(eyr) |> (fn {x, rest} -> x >= 2020 and x <= 2030 and rest == "" end).()

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
    Enum.reduce(
      input,
      MapSet.new(),
      fn val, mapset -> MapSet.put(mapset, String.split(val, ":") |> List.first()) end
    )
  end

  @spec part1(String.t()) :: non_neg_integer()
  def part1(filename) do
    keys = MapSet.new(~w[byr iyr eyr hgt hcl ecl pid])

    read_chunked_lines(filename)
    |> parse_input()
    |> Enum.map(&build_set(&1))
    |> Enum.map(&MapSet.subset?(keys, &1))
    |> Enum.count(& &1)
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
    |> Enum.map(fn {set, valid_keys} -> MapSet.subset?(keys, set) and valid_keys end)
    |> Enum.count(& &1)
  end
end

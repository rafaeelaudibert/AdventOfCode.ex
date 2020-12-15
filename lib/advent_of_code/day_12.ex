import AdventOfCode.Helpers.Input

defmodule AdventOfCode.Day12 do
  @type command :: {String.t(), non_neg_integer()}
  @type position :: {integer(), integer(), {integer(), integer()}}

  @spec new_dir({integer(), integer()}, {String.t(), non_neg_integer()}) :: {integer(), integer()}
  defp new_dir(dir, {_, 0}), do: dir

  defp new_dir({east_dir, north_dir}, {direction, rotation}) do
    rotated90 =
      case direction do
        "R" -> {north_dir, -east_dir}
        "L" -> {-north_dir, east_dir}
      end

    new_dir(rotated90, {direction, rotation - 90})
  end

  @spec move_boat_rules_1(command(), position()) :: position()
  defp move_boat_rules_1({command, value}, {east_pos, north_pos, {east_dir, north_dir}}) do
    case command do
      "N" -> {east_pos, north_pos + value, {east_dir, north_dir}}
      "S" -> {east_pos, north_pos - value, {east_dir, north_dir}}
      "E" -> {east_pos + value, north_pos, {east_dir, north_dir}}
      "W" -> {east_pos - value, north_pos, {east_dir, north_dir}}
      "L" -> {east_pos, north_pos, new_dir({east_dir, north_dir}, {command, value})}
      "R" -> {east_pos, north_pos, new_dir({east_dir, north_dir}, {command, value})}
      "F" -> {east_pos + east_dir * value, north_pos + north_dir * value, {east_dir, north_dir}}
    end
  end

  @spec move_boat_rules_2(command(), position()) :: position()
  defp move_boat_rules_2({command, value}, {east_pos, north_pos, {east_dir, north_dir}}) do
    case command do
      "N" -> {east_pos, north_pos, {east_dir, north_dir + value}}
      "S" -> {east_pos, north_pos, {east_dir, north_dir - value}}
      "E" -> {east_pos, north_pos, {east_dir + value, north_dir}}
      "W" -> {east_pos, north_pos, {east_dir - value, north_dir}}
      "L" -> {east_pos, north_pos, new_dir({east_dir, north_dir}, {command, value})}
      "R" -> {east_pos, north_pos, new_dir({east_dir, north_dir}, {command, value})}
      "F" -> {east_pos + east_dir * value, north_pos + north_dir * value, {east_dir, north_dir}}
    end
  end

  @spec input_to_command([String.t()]) :: command
  defp input_to_command([command, value]) do
    {command, String.to_integer(value)}
  end

  @spec part1(String.t()) :: non_neg_integer()
  def part1(filename) do
    read_lines(filename)
    |> Enum.map(&(&1 |> String.split("", parts: 3) |> Enum.drop(1) |> input_to_command()))
    |> Enum.reduce({0, 0, {1, 0}}, &move_boat_rules_1/2)
    |> (fn {east_pos, north_pos, _} -> abs(east_pos) + abs(north_pos) end).()
  end

  @spec part2(String.t()) :: non_neg_integer()
  def part2(filename) do
    read_lines(filename)
    |> Enum.map(&(&1 |> String.split("", parts: 3) |> Enum.drop(1) |> input_to_command()))
    |> Enum.reduce({0, 0, {10, 1}}, &move_boat_rules_2/2)
    |> (fn {east_pos, north_pos, _} -> abs(east_pos) + abs(north_pos) end).()
  end
end

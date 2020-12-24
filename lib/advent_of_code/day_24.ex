import AdventOfCode.Helpers.Input

defmodule AdventOfCode.Day24 do
  @type coord_diff :: {-1 | 0 | 1, -1 | 0 | 1}

  @spec parse_coords([String.t()]) :: [coord_diff]
  defp parse_coords([]), do: []

  defp parse_coords([first_char | tail]) do
    if first_char in ["e", "w"] do
      [dir_to_coord(first_char) | parse_coords(tail)]
    else
      [second_char | tail] = tail
      [dir_to_coord("#{first_char}#{second_char}") | parse_coords(tail)]
    end
  end

  @spec dir_to_coord(String.t()) :: coord_diff
  defp dir_to_coord(dir) do
    case dir do
      "e" -> {1, 0}
      "w" -> {-1, 0}
      "se" -> {0, 1}
      "sw" -> {-1, 1}
      "ne" -> {1, -1}
      "nw" -> {0, -1}
    end
  end

  @spec invert(:black | :white) :: :white | :black
  defp invert(:black), do: :white
  defp invert(:white), do: :black

  @spec get_board([String.t()]) :: %{}
  defp get_board(string_coordinates) do
    Enum.map(string_coordinates, fn line ->
      line
      |> String.graphemes()
      |> parse_coords()
      |> Enum.reduce({0, 0}, fn {dx, dy}, {x, y} -> {dx + x, dy + y} end)
    end)
    |> Enum.reduce(%{}, fn coord, map ->
      Map.update(map, coord, :black, fn old_val -> invert(old_val) end)
    end)
  end

  @spec iterate(%{}, non_neg_integer()) :: %{}
  defp iterate(map, 0), do: map

  defp iterate(original_map, count) do
    directions = [{1, 0}, {-1, 0}, {0, 1}, {-1, 1}, {1, -1}, {0, -1}]

    map_as_list = Enum.to_list(original_map)

    white_neighbours =
      map_as_list
      |> Enum.filter(fn {_, color} -> color == :black end)
      |> Enum.flat_map(fn {{x, y}, _} ->
        Enum.map(directions, fn {dx, dy} -> {{x + dx, y + dy}, :white} end)
      end)

    # We could have created some "white neighbours" which are actually black
    # in the board already. This problem is solved because uniq_by keeps the same value found
    # if it finds duplicates. This way, as the "original ones" are found first in the list,
    # they are kept in the right color
    checkable = (map_as_list ++ white_neighbours) |> Enum.uniq_by(fn {coords, _} -> coords end)

    map =
      Enum.reduce(checkable, %{}, fn {{x, y}, color}, map ->
        black_count =
          Enum.count(directions, fn {dx, dy} -> original_map[{x + dx, y + dy}] == :black end)

        new_color =
          case color do
            :white when black_count == 2 -> :black
            :black when black_count == 0 or black_count > 2 -> :white
            color -> color
          end

        Map.put(map, {x, y}, new_color)
      end)

    iterate(map, count - 1)
  end

  @spec part1(String.t()) :: non_neg_integer()
  def part1(filename) do
    read_lines(filename)
    |> get_board()
    |> Map.values()
    |> Enum.count(&(&1 == :black))
  end

  @spec part2(String.t()) :: non_neg_integer()
  def part2(filename) do
    read_lines(filename)
    |> get_board()
    |> iterate(100)
    |> Map.values()
    |> Enum.count(&(&1 == :black))
  end
end

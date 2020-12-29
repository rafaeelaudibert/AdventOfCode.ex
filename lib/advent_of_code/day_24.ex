import AdventOfCode.Helpers.Input

defmodule AdventOfCode.Day24 do
  @directions [{1, 0}, {-1, 0}, {0, 1}, {-1, 1}, {1, -1}, {0, -1}]

  @type coord_diff :: {-1 | 0 | 1, -1 | 0 | 1}
  @type dir :: :e | :se | :ne | :w | :sw | :nw
  @type color :: :black | :white
  @type board :: %{}

  @spec parse_coords(String.t()) :: [coord_diff]
  defp parse_coords(""), do: []

  defp parse_coords(coords_left) do
    {dir, coords_left} =
      case coords_left do
        "e" <> coords_left -> {:e, coords_left}
        "se" <> coords_left -> {:se, coords_left}
        "ne" <> coords_left -> {:ne, coords_left}
        "w" <> coords_left -> {:w, coords_left}
        "sw" <> coords_left -> {:sw, coords_left}
        "nw" <> coords_left -> {:nw, coords_left}
      end

    [dir_to_coord(dir) | parse_coords(coords_left)]
  end

  @spec dir_to_coord(dir) :: coord_diff
  defp dir_to_coord(dir) do
    case dir do
      :e -> {1, 0}
      :w -> {-1, 0}
      :se -> {0, 1}
      :sw -> {-1, 1}
      :ne -> {1, -1}
      :nw -> {0, -1}
    end
  end

  @spec invert(:black | :white) :: :white | :black
  defp invert(:black), do: :white
  defp invert(:white), do: :black

  @spec get_board([String.t()]) :: board()
  defp get_board(string_coordinates) do
    Enum.map(string_coordinates, fn line ->
      line
      |> parse_coords()
      |> Enum.reduce({0, 0}, fn {dx, dy}, {x, y} -> {dx + x, dy + y} end)
    end)
    |> Enum.reduce(%{}, fn coord, map ->
      Map.update(map, coord, :black, fn old_val -> invert(old_val) end)
    end)
    |> Enum.filter(fn {_, color} -> color == :black end)
    |> Enum.into(%{})
  end

  @spec iterate(board(), non_neg_integer()) :: board()
  defp iterate(map, 0), do: map

  defp iterate(map, count) do
    list_map = Enum.to_list(map)

    white_neighbours =
      map
      |> Enum.flat_map(fn {{x, y}, _} ->
        Enum.map(@directions, fn {dx, dy} -> {{x + dx, y + dy}, :white} end)
      end)

    # We could have created some "white neighbours" which are actually black
    # in the board already. This problem is solved because uniq_by keeps the same value found
    # if it finds duplicates. This way, as the "original ones" are found first in the list,
    # they are kept in the right color
    checkable = (list_map ++ white_neighbours) |> Enum.uniq_by(fn {coords, _} -> coords end)

    map =
      Enum.map(checkable, fn {{x, y}, color} ->
        black_count = Enum.count(@directions, fn {dx, dy} -> map[{x + dx, y + dy}] == :black end)

        new_color =
          case color do
            :white when black_count == 2 -> :black
            :black when black_count == 0 or black_count > 2 -> :white
            color -> color
          end

        {{x, y}, new_color}
      end)
      |> Enum.filter(fn {_, color} -> color == :black end)
      |> Enum.into(%{})

    iterate(map, count - 1)
  end

  @spec part1(String.t()) :: non_neg_integer()
  def part1(filename) do
    read_lines(filename)
    |> get_board()
    |> map_size()
  end

  @spec part2(String.t()) :: non_neg_integer()
  def part2(filename) do
    read_lines(filename)
    |> get_board()
    |> iterate(100)
    |> map_size()
  end
end

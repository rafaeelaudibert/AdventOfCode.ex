import AdventOfCode.Helpers.Input

defmodule AdventOfCode.Day20 do
  @type line :: [String.t()]
  @type edges :: %{
          top: line,
          bottom: line,
          left: line,
          right: line
        }
  @type tile :: %{
          tile_number: non_neg_integer(),
          lines: [line],
          edges: edges,
          reversed_edges: edges
        }

  @spec parse_input(String.t()) :: [tile]
  defp parse_input(filename) do
    read_chunked_lines(filename)
    |> Enum.map(fn [header | lines] ->
      tile_number =
        Regex.named_captures(~r/Tile (?<number>\d+)/, header)["number"] |> String.to_integer()

      lines = Enum.map(lines, &String.graphemes/1)
      zipped_lines = Enum.zip(lines) |> Enum.map(&Tuple.to_list/1)

      top = List.first(lines)
      bottom = List.last(lines)
      left = List.first(zipped_lines)
      right = List.last(zipped_lines)

      edges = %{top: top, bottom: bottom, left: left, right: right}

      reversed_edges =
        Enum.map(edges, fn {dir, line} -> {dir, Enum.reverse(line)} end) |> Enum.into(%{})

      %{
        tile_number: tile_number,
        lines: lines,
        edges: edges,
        reversed_edges: reversed_edges
      }
    end)
  end

  def solve(tiles) do
    Enum.map(tiles, fn %{
                         tile_number: tile_number,
                         edges: edges,
                         reversed_edges: reversed_edges
                       } = tile ->
      zipped_edges = Enum.zip(edges, reversed_edges)

      connections =
        Enum.map(zipped_edges, fn
          {{dir, edge}, {_, reversed_edge}} ->
            matching_edge =
              Enum.find_value(tiles, fn
                %{tile_number: ^tile_number} ->
                  nil

                other_tile ->
                  Enum.find_value(other_tile.edges, fn {other_dir, other_edge} ->
                    matches? = other_edge == edge
                    if matches?, do: {other_tile, other_dir}
                  end)
              end)

            matching_reversed_edge =
              Enum.find_value(tiles, fn
                %{tile_number: ^tile_number} ->
                  nil

                other_tile ->
                  Enum.find_value(other_tile.edges, fn {other_dir, other_edge} ->
                    matches? = other_edge == reversed_edge
                    if matches?, do: {other_tile, other_dir}
                  end)
              end)

            cond do
              matching_edge != nil ->
                {me_tile, me_dir} = matching_edge
                {:regular, dir, me_tile.tile_number, me_dir}

              matching_reversed_edge != nil ->
                {me_tile, me_dir} = matching_reversed_edge
                {:reversed, dir, me_tile.tile_number, me_dir}

              true ->
                {:no_connection, dir, nil, nil}
            end
        end)

      %{tile: tile, connections: connections}
    end)
  end
  @spec part1(String.t()) :: non_neg_integer()
  def part1(filename) do
    parse_input(filename)
    |> solve()
    |> Enum.filter(fn %{connections: connections} ->
      Enum.count(
        connections,
        fn
          {:no_connection, _, _, _} -> true
          _ -> false
        end
      ) == 2
    end)
    |> Enum.map(fn %{tile: %{tile_number: tile_number}} -> tile_number end)
    |> Enum.reduce(&*/2)
  end

  @spec part2(String.t()) :: non_neg_integer()
  def part2(filename) do
    _input = read_integers(filename)
    0
  end
end

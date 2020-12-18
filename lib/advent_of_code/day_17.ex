import AdventOfCode.Helpers.Input

defmodule AdventOfCode.Day17 do
  @spec generate_movements(non_neg_integer()) :: [[non_neg_integer()]]
  defp generate_movements(1), do: [[-1], [0], [1]]

  defp generate_movements(dimensions) when dimensions > 1 do
    Enum.flat_map(generate_movements(dimensions - 1), fn movement ->
      [[-1] ++ movement, [0] ++ movement, [1] ++ movement]
    end)
  end

  @spec input_to_board([String.t()], non_neg_integer(), any()) :: MapSet.t()
  defp input_to_board(input, dim, filler \\ 0) do
    tuple_filler = Tuple.duplicate(filler, dim - 2) |> Tuple.to_list()

    Enum.with_index(input)
    |> Enum.reduce(MapSet.new(), fn {line, idx_line}, map ->
      String.graphemes(line)
      |> Enum.with_index()
      |> Enum.reduce(map, fn {col, idx_col}, map ->
        if col == "#" do
          tuple = (tuple_filler ++ [idx_line, idx_col]) |> List.to_tuple()
          MapSet.put(map, tuple)
        else
          map
        end
      end)
    end)
  end

  defp get_bbox(board) do
    Enum.to_list(board)
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&Enum.min_max/1)
  end

  defp steps_3d(board, 0), do: board

  defp steps_3d(board, steps) do
    movements = generate_movements(3)
    [{minz, maxz}, {miny, maxy}, {minx, maxx}] = get_bbox(board)

    board =
      Enum.reduce((minz - 1)..(maxz + 1), MapSet.new(), fn z, map ->
        Enum.reduce((miny - 1)..(maxy + 1), map, fn y, map ->
          Enum.reduce((minx - 1)..(maxx + 1), map, fn x, map ->
            neighbours =
              Enum.count(movements, fn [dz, dy, dx] ->
                pos = {z + dz, y + dy, x + dx}
                MapSet.member?(board, pos)
              end)

            pos = {z, y, x}

            cond do
              # Notice that it is [3, 4] and to [2, 3] because we are counting
              # itself as a neighbour
              MapSet.member?(board, pos) and neighbours in [3, 4] ->
                MapSet.put(map, pos)

              not MapSet.member?(board, pos) and neighbours == 3 ->
                MapSet.put(map, pos)

              true ->
                map
            end
          end)
        end)
      end)

    steps_3d(board, steps - 1)
  end

  defp steps_4d(board, 0), do: board

  defp steps_4d(board, steps) do
    movements = generate_movements(4)
    [{minw, maxw}, {minz, maxz}, {miny, maxy}, {minx, maxx}] = get_bbox(board)

    board =
      Enum.reduce((minw - 1)..(maxw + 1), MapSet.new(), fn w, map ->
        Enum.reduce((minz - 1)..(maxz + 1), map, fn z, map ->
          Enum.reduce((miny - 1)..(maxy + 1), map, fn y, map ->
            Enum.reduce((minx - 1)..(maxx + 1), map, fn x, map ->
              neighbours =
                Enum.count(movements, fn [dw, dz, dy, dx] ->
                  pos = {w + dw, z + dz, y + dy, x + dx}
                  MapSet.member?(board, pos)
                end)

              pos = {w, z, y, x}

              cond do
                # Notice that it is [3, 4] and to [2, 3] because we are counting
                # itself as a neighbour
                MapSet.member?(board, pos) and neighbours in [3, 4] ->
                  MapSet.put(map, pos)

                not MapSet.member?(board, pos) and neighbours == 3 ->
                  MapSet.put(map, pos)

                true ->
                  map
              end
            end)
          end)
        end)
      end)

    steps_4d(board, steps - 1)
  end

  @spec part1(String.t()) :: non_neg_integer()
  def part1(filename) do
    read_lines(filename) |> input_to_board(3) |> steps_3d(6) |> MapSet.size()
  end

  @spec part2(String.t()) :: non_neg_integer()
  def part2(filename) do
    read_lines(filename) |> input_to_board(4) |> steps_4d(6) |> MapSet.size()
  end
end

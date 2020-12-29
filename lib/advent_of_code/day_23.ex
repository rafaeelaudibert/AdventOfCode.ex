import AdventOfCode.Helpers.Input

defmodule AdventOfCode.Day23 do
  @spec window({}) :: [{any(), any()}]
  defp window(tuple) do
    tsize = tuple_size(tuple)

    Stream.unfold(1, fn
      ^tsize -> nil
      size -> {{elem(tuple, size - 1), elem(tuple, size)}, size + 1}
    end)
    |> Enum.to_list()
  end

  @spec traverse_linked_list(%{}, non_neg_integer(), non_neg_integer()) :: [non_neg_integer()]
  defp traverse_linked_list(map, start, depth) do
    Stream.iterate(start, &map[&1]) |> Stream.take(depth) |> Enum.to_list()
  end

  @spec get_destination(non_neg_integer(), non_neg_integer(), MapSet.t()) :: non_neg_integer()
  def get_destination(current, max, removed_set) do
    Stream.iterate(rem(current - 2 + max, max) + 1, &(rem(&1 - 2 + max, max) + 1))
    |> Enum.find(fn val -> not MapSet.member?(removed_set, val) end)
  end

  @spec play(%{}, non_neg_integer(), non_neg_integer(), non_neg_integer(), non_neg_integer()) ::
          %{}
  defp play(map, _, _, 0, _), do: map

  defp play(map, current, max, rounds, max_rounds) do
    if rem(rounds, 10000) == 0,
      do: ProgressBar.render(10_000_000 - rounds, 10_000_000, suffix: :count)

    removed = traverse_linked_list(map, map[current], 4)
    [first, second, last, next] = removed
    removed_set = MapSet.new([first, second, last])
    destination = get_destination(current, max, removed_set)

    new_map =
      Map.put(map, current, next)
      |> Map.put(destination, first)
      |> Map.put(last, map[destination])

    play(new_map, new_map[current], max, rounds - 1, max_rounds)
  end

  @spec map_to_string(%{}, non_neg_integer(), non_neg_integer()) :: String.t()
  defp map_to_string(map, start, size),
    do: traverse_linked_list(map, start, size) |> Enum.drop(1) |> Enum.join("")

  @spec part1(String.t()) :: String.t()
  def part1(filename) do
    input =
      read_lines(filename)
      |> List.first()
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer/1)

    first = Enum.at(input, 0)
    last = Enum.at(input, -1)

    max = Enum.max(input)
    rounds = 100

    List.to_tuple(input)
    |> window()
    |> Enum.into(Map.put(%{}, last, first))
    |> play(first, max, rounds, rounds)
    |> map_to_string(1, max)
  end

  @spec part2(String.t()) :: non_neg_integer()
  def part2(filename) do
    expand_until = 1_000_000
    rounds = 10_000_000

    input =
      read_lines(filename)
      |> List.first()
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer/1)

    max = Enum.max(input)
    first = Enum.at(input, 0)

    # Fill the missing ones in the input
    input =
      (input ++ (Stream.iterate(max + 1, &(&1 + 1)) |> Enum.take(expand_until - max)))
      |> List.to_tuple()

    window(input)
    |> Enum.into(Map.put(%{}, expand_until, first))
    |> play(first, expand_until, rounds + 1, rounds)
    |> (&(&1[1] * &1[&1[1]])).()
  end
end

import AdventOfCode.Helpers.Input

defmodule AdventOfCode.Day22 do
  @type deck :: [non_neg_integer()]

  @spec step([deck]) :: [deck]
  defp step([[top1 | tail1], [top2 | tail2]]) when top1 > top2,
    do: [tail1 ++ [top1, top2], tail2]

  defp step([[top1 | tail1], [top2 | tail2]]) when top2 > top1,
    do: [tail1, tail2 ++ [top2, top1]]

  # When there is no matching in above patterns,
  # someone has no cards, game has ended
  defp step(_), do: nil

  @spec play_game([deck]) :: [deck]
  defp play_game(decks) do
    Stream.iterate(decks, &step/1)
    |> Stream.take_while(& &1)
    |> Enum.to_list()
    |> List.last()
  end

  @spec play_recursive_game([deck]) :: [deck]
  defp play_recursive_game(decks), do: play_recursive_game(decks, MapSet.new())

  defp play_recursive_game([deck1, deck2] = decks, seen, depth \\ 0) do
    max_deck1 = Enum.max(deck1)
    max_deck2 = Enum.max(deck2)

    if depth > 0 and max_deck1 > max_deck2 and max_deck1 > length(deck1) + length(deck2) - 2 do
      # Optimization by curious_sapi3n at Reddit
      # If it is a sub game, and the player 1 has the maximum card, it will win
      # https://www.reddit.com/r/adventofcode/comments/khyjgv/2020_day_22_solutions/ggpcsnd?utm_source=share&utm_medium=web2x&context=3
      [deck1 ++ deck2, []]
    else
      Stream.iterate({decks, seen}, fn
        {[deck1, deck2], _} when length(deck1) == 0 or length(deck2) == 0 ->
          nil

        {[[top1 | tail1], [top2 | tail2]] = decks, seen} ->
          new_seen = MapSet.put(seen, decks)

          cond do
            MapSet.member?(seen, decks) ->
              {[tail1 ++ [top1, top2] ++ tail2, []], seen}

            length(tail1) < top1 or length(tail2) < top2 ->
              {step(decks), new_seen}

            # Recursive subgame
            true ->
              subgame =
                play_recursive_game(
                  [Enum.take(tail1, top1), Enum.take(tail2, top2)],
                  MapSet.new(),
                  depth + 1
                )

              winner = which_winner(subgame)

              if winner == :player1,
                do: {[tail1 ++ [top1, top2], tail2], new_seen},
                else: {[tail1, tail2 ++ [top2, top1]], new_seen}
          end
      end)
      |> Stream.take_while(& &1)
      |> Enum.to_list()
      |> List.last()
      |> (fn {decks, _} -> decks end).()
    end
  end

  @spec which_winner([deck]) :: :player1 | :player2 | :unfinished
  defp which_winner([_, []]), do: :player1
  defp which_winner([[], _]), do: :player2
  defp which_winner(_), do: :unfinished

  @spec part1(String.t()) :: non_neg_integer()
  def part1(filename) do
    read_chunked_lines(filename)
    |> Enum.map(fn [_ | cards] -> Enum.map(cards, &String.to_integer/1) end)
    |> play_game()
    |> Enum.flat_map(& &1)
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.reduce(0, fn {val, multiplier}, acc -> acc + val * (multiplier + 1) end)
  end

  @spec part2(String.t()) :: non_neg_integer()
  def part2(filename) do
    read_chunked_lines(filename)
    |> Enum.map(fn [_ | cards] -> Enum.map(cards, &String.to_integer/1) end)
    |> play_recursive_game()
    |> Enum.flat_map(& &1)
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.reduce(0, fn {val, multiplier}, acc -> acc + val * (multiplier + 1) end)
  end
end

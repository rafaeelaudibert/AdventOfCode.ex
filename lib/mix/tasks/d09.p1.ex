defmodule Mix.Tasks.D09.P1 do
  use Mix.Task

  @shortdoc "Day 09 Part 1"
  def run(args) do
    filename = Path.join(File.cwd!(), "input/input09.txt")

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> filename |> AdventOfCode.Day09.part1() end}),
      else:
        filename
        |> AdventOfCode.Day09.part1()
        |> IO.inspect(label: "Part 1 Results")
  end
end

defmodule Mix.Tasks.D05.P1 do
  use Mix.Task

  @shortdoc "Day 05 Part 1"
  def run(args) do
    filename = Path.join(File.cwd!(), "input/input05.txt")

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> filename |> AdventOfCode.Day05.part1() end}),
      else:
        filename
        |> AdventOfCode.Day05.part1()
        |> IO.inspect(label: "Part 1 Results")
  end
end

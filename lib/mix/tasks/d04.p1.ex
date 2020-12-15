defmodule Mix.Tasks.D04.P1 do
  use Mix.Task

  @shortdoc "Day 04 Part 1"
  def run(args) do
    filename = Path.join(File.cwd!(), "input/input04.txt")

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> filename |> AdventOfCode.Day04.part1() end}),
      else:
        filename
        |> AdventOfCode.Day04.part1()
        |> IO.inspect(label: "Part 1 Results")
  end
end

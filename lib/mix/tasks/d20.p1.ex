defmodule Mix.Tasks.D20.P1 do
  use Mix.Task

  @shortdoc "Day 20 Part 1"
  def run(args) do
    filename = Path.join(File.cwd!(), "input/input20.txt")

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> filename |> AdventOfCode.Day20.part1() end}),
      else:
        filename
        |> AdventOfCode.Day20.part1()
        |> IO.inspect(label: "Part 1 Results")
  end
end

defmodule Mix.Tasks.D13.P1 do
  use Mix.Task

  @shortdoc "Day 13 Part 1"
  def run(args) do
    filename = Path.join(File.cwd!(), "input/input13.txt")

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> filename |> AdventOfCode.Day13.part1() end}),
      else:
        filename
        |> AdventOfCode.Day13.part1()
        |> IO.inspect(label: "Part 1 Results")
  end
end

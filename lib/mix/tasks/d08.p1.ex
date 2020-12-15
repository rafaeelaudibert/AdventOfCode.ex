defmodule Mix.Tasks.D08.P1 do
  use Mix.Task

  @shortdoc "Day 08 Part 1"
  def run(args) do
    filename = Path.join(File.cwd!(), "input/input08.txt")

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> filename |> AdventOfCode.Day08.part1() end}),
      else:
        filename
        |> AdventOfCode.Day08.part1()
        |> IO.inspect(label: "Part 1 Results")
  end
end

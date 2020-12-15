defmodule Mix.Tasks.D06.P1 do
  use Mix.Task

  @shortdoc "Day 06 Part 1"
  def run(args) do
    filename = Path.join(File.cwd!(), "input/input06.txt")

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> filename |> AdventOfCode.Day06.part1() end}),
      else:
        filename
        |> AdventOfCode.Day06.part1()
        |> IO.inspect(label: "Part 1 Results")
  end
end

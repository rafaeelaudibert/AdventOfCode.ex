defmodule Mix.Tasks.D16.P1 do
  use Mix.Task

  @shortdoc "Day 16 Part 1"
  def run(args) do
    filename = Path.join(File.cwd!(), "input/input16.txt")

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> filename |> AdventOfCode.Day16.part1() end}),
      else:
        filename
        |> AdventOfCode.Day16.part1()
        |> IO.inspect(label: "Part 1 Results")
  end
end

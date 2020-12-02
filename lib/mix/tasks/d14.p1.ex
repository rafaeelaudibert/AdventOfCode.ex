defmodule Mix.Tasks.D14.P1 do
  use Mix.Task
  
  @shortdoc "Day 14 Part 1"
  def run(args) do
    test_filename = Path.join(File.cwd!, "input/input14.txt")

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> test_filename |> AdventOfCode.Day14.part1() end }),
      else:
        test_filename
        |> AdventOfCode.Day14.part1()
        |> IO.inspect(label: "Part 1 Results")
  end
end

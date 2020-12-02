defmodule Mix.Tasks.D21.P1 do
  use Mix.Task
  
  @shortdoc "Day 21 Part 1"
  def run(args) do
    test_filename = Path.join(File.cwd!, "input/input21.txt")

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> test_filename |> AdventOfCode.Day21.part1() end }),
      else:
        test_filename
        |> AdventOfCode.Day21.part1()
        |> IO.inspect(label: "Part 1 Results")
  end
end

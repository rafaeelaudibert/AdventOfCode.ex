defmodule Mix.Tasks.D21.P2 do
  use Mix.Task
  
  @shortdoc "Day 21 Part 2"
  def run(args) do
    test_filename = Path.join(File.cwd!, "input/input21.txt")

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_2: fn -> test_filename |> AdventOfCode.Day21.part2() end }),
      else:
        test_filename
        |> AdventOfCode.Day21.part2()
        |> IO.inspect(label: "Part 2 Results")
  end
end

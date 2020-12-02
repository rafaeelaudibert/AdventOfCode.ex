defmodule Mix.Tasks.D07.P2 do
  use Mix.Task
  
  @shortdoc "Day 07 Part 2"
  def run(args) do
    test_filename = Path.join(File.cwd!, "input/input07.txt")

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_2: fn -> test_filename |> AdventOfCode.Day07.part2() end }),
      else:
        test_filename
        |> AdventOfCode.Day07.part2()
        |> IO.inspect(label: "Part 2 Results")
  end
end

defmodule Mix.Tasks.D12.P2 do
  use Mix.Task
  
  @shortdoc "Day 12 Part 2"
  def run(args) do
    test_filename = Path.join(File.cwd!, "input/input12.txt")

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_2: fn -> test_filename |> AdventOfCode.Day12.part2() end }),
      else:
        test_filename
        |> AdventOfCode.Day12.part2()
        |> IO.inspect(label: "Part 2 Results")
  end
end

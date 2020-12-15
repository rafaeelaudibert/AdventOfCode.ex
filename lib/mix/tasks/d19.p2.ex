defmodule Mix.Tasks.D19.P2 do
  use Mix.Task

  @shortdoc "Day 19 Part 2"
  def run(args) do
    filename = Path.join(File.cwd!(), "input/input19.txt")

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_2: fn -> filename |> AdventOfCode.Day19.part2() end}),
      else:
        filename
        |> AdventOfCode.Day19.part2()
        |> IO.inspect(label: "Part 2 Results")
  end
end

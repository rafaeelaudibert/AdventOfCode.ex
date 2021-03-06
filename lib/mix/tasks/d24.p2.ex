defmodule Mix.Tasks.D24.P2 do
  use Mix.Task

  @shortdoc "Day 24 Part 2"
  def run(args) do
    filename = Path.join(File.cwd!(), "input/input24.txt")

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_2: fn -> filename |> AdventOfCode.Day24.part2() end}),
      else:
        filename
        |> AdventOfCode.Day24.part2()
        |> IO.inspect(label: "Part 2 Results")
  end
end

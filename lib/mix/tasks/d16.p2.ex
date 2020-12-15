defmodule Mix.Tasks.D16.P2 do
  use Mix.Task

  @shortdoc "Day 16 Part 2"
  def run(args) do
    filename = Path.join(File.cwd!(), "input/input16.txt")

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_2: fn -> filename |> AdventOfCode.Day16.part2() end}),
      else:
        filename
        |> AdventOfCode.Day16.part2()
        |> IO.inspect(label: "Part 2 Results")
  end
end

defmodule Mix.Tasks.D23.P2 do
  use Mix.Task

  @shortdoc "Day 23 Part 2"
  def run(args) do
    filename = Path.join(File.cwd!(), "input/input23.txt")

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_2: fn -> filename |> AdventOfCode.Day23.part2() end}),
      else:
        filename
        |> AdventOfCode.Day23.part2()
        |> IO.inspect(label: "Part 2 Results")
  end
end

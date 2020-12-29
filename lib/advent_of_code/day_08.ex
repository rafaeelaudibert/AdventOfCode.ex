import AdventOfCode.Helpers.Input

defmodule AdventOfCode.Day08 do
  @spec part1(String.t()) :: non_neg_integer()
  def part1(filename) do
    computer =
      read_lines(filename)
      |> AdventOfCode.Computer.build_from_input()
      |> AdventOfCode.Computer.step_until_halted_or_loop()

    computer.accumulator
  end

  @spec part2(String.t()) :: non_neg_integer()
  def part2(filename) do
    input = read_lines(filename)

    parent = self()

    Enum.map(0..(length(input) - 1), fn idx_to_change ->
      command = Enum.at(input, idx_to_change)
      [opcode, _] = command |> String.split(" ")

      cond do
        opcode == "jmp" ->
          List.replace_at(input, idx_to_change, String.replace(command, "jmp", "nop"))

        opcode == "nop" ->
          List.replace_at(input, idx_to_change, String.replace(command, "nop", "jmp"))

        true ->
          nil
      end
    end)
    |> Enum.filter(& &1)
    |> Enum.map(&(&1 |> AdventOfCode.Computer.build_from_input()))
    |> Enum.map(
      &spawn(fn ->
        AdventOfCode.Computer.step_until_halted_or_loop(&1)
        |> (fn result -> send(parent, {self(), result}) end).()
      end)
    )
    |> Enum.find_value(fn pid ->
      receive do
        {^pid, result} -> if result.is_halted, do: result.accumulator
      end
    end)
  end
end

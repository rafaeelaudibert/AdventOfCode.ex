import AdventOfCode.Helpers.Input

defmodule AdventOfCode.Day08 do
  def until_halted_or_loop({computer, repeated}) do
    new_computer = AdventOfCode.Computer.step(computer)

    if computer.is_halted or MapSet.member?(repeated, computer.program_counter),
      do: nil,
      else: {
        new_computer,
        {
          new_computer,
          MapSet.put(repeated, computer.program_counter)
        }
      }
  end

  @spec part1(String.t()) :: non_neg_integer()
  def part1(test_filename) do
    read_lines(test_filename)
    |> AdventOfCode.Computer.build_from_input()
    |> AdventOfCode.Computer.step_until_halted_or_loop()
    |> (& &1.accumulator).()
  end

  @spec part2(String.t()) :: non_neg_integer()
  def part2(test_filename) do
    input = read_lines(test_filename)

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
        |> (fn pid -> send(parent, {self(), pid}) end).()
      end)
    )
    |> Enum.find_value(fn pid ->
      receive do
        {^pid, result} -> if result.is_halted, do: result.accumulator
      end
    end)
  end
end

defmodule AdventOfCode.Computer do
  @enforce_keys [:instructions]
  defstruct program_counter: 0, accumulator: 0, instructions: [], is_halted: false

  def build_from_input(commands) do
    instructions =
      commands
      |> Enum.map(fn command ->
        String.split(command, " ")
        |> (fn [opcode, op1] -> {opcode, Integer.parse(op1) |> elem(0)} end).()
      end)

    %AdventOfCode.Computer{instructions: instructions}
  end

  @spec step(%AdventOfCode.Computer{}) :: %AdventOfCode.Computer{}
  def step(%AdventOfCode.Computer{is_halted: true} = computer),
    do: computer

  def step(
        %AdventOfCode.Computer{
          instructions: instructions,
          program_counter: program_counter,
          accumulator: accumulator
        } = computer
      ) do
    command = Enum.at(instructions, program_counter)

    case command do
      nil ->
        %{computer | is_halted: true}

      {"acc", val} ->
        %{
          computer
          | accumulator: accumulator + val,
            program_counter: program_counter + 1
        }

      {"jmp", val} ->
        %{computer | program_counter: program_counter + val}

      _ ->
        # A nop, or any non implemented operation
        %{computer | program_counter: program_counter + 1}
    end
  end

  @spec step_until_halted_or_loop(%AdventOfCode.Computer{}) :: %AdventOfCode.Computer{}
  def step_until_halted_or_loop(computer) do
    Stream.unfold({computer, MapSet.new()}, fn {computer, repeated} ->
      new_computer = step(computer)

      if computer.is_halted or MapSet.member?(repeated, computer.program_counter),
        do: nil,
        else: {
          new_computer,
          {
            new_computer,
            MapSet.put(repeated, computer.program_counter)
          }
        }
    end)
    |> Enum.to_list()
    |> List.last()
  end
end

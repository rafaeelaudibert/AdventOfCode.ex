import AdventOfCode.Helpers.Input

defmodule AdventOfCode.Day18 do
  @spec get_next_token([String.t()]) :: {String.t(), [String.t()]}
  defp get_next_token([token | expression]) do
    if token == " ", do: get_next_token(expression), else: {token, expression}
  end

  @spec operate([String.t()], [String.t()], boolean(), boolean()) :: {[String.t()], [String.t()]}
  defp operate(val_stack, op_stack, consume_parentheses \\ false, consume_multiplication \\ false) do
    case {val_stack, op_stack} do
      # Parentheses
      {[")" | [val | rest_val_stack]], op_stack} ->
        operate([val | rest_val_stack], op_stack, true, consume_multiplication)

      {[val | ["(" | rest_val_stack]], op_stack} when consume_parentheses == true ->
        operate([val | rest_val_stack], op_stack, false, consume_multiplication)

      {_, []} ->
        {val_stack, op_stack}

      {[val1 | [val2 | rest_val_stack]], [op | rest_op]} when val2 != "(" ->
        case op do
          "+" ->
            operate([val1 + val2 | rest_val_stack], rest_op)

          "*" when consume_multiplication == true or consume_parentheses == true ->
            operate(
              [val1 * val2 | rest_val_stack],
              rest_op,
              consume_parentheses,
              consume_multiplication
            )

          _ ->
            {val_stack, op_stack}
        end

      {val_stack, op_stack} ->
        {val_stack, op_stack}
    end
  end

  # Header with default opts
  @spec solve([String.t()], [String.t()], [boolean()]) :: integer()
  defp solve(
         _,
         val_stack \\ [],
         op_stack \\ [],
         opts \\ [consume_parentheses: false, consume_multiplication: false]
       )

  defp solve([], val_stack, op_stack, _),
    do:
      operate(val_stack, op_stack, true, true)
      |> (fn {val_stack, _} -> Enum.at(val_stack, 0) end).()

  defp solve(expression, val_stack, op_stack, opts) do
    consume_parentheses = opts[:consume_parentheses] || false
    consume_multiplication = opts[:consume_multiplication] || false

    {char, expression} = get_next_token(expression)

    parsed =
      case Integer.parse(char) do
        :error -> {:symbol, char}
        {number, _} -> {:number, number}
      end

    {val_stack, op_stack} =
      case parsed do
        {:symbol, char} when char == ")" ->
          operate([")" | val_stack], op_stack, consume_parentheses, consume_multiplication)

        {:symbol, char} when char == "(" ->
          {["(" | val_stack], op_stack}

        {:symbol, char} ->
          {val_stack, [char | op_stack]}

        {:number, val} ->
          operate([val | val_stack], op_stack, consume_parentheses, consume_multiplication)
      end

    solve(expression, val_stack, op_stack, opts)
  end

  @spec part1(String.t()) :: non_neg_integer()
  def part1(filename) do
    read_lines(filename)
    |> Enum.map(&solve(String.graphemes(&1), [], [], consume_multiplication: true))
    |> Enum.sum()
  end

  @spec part2(String.t()) :: non_neg_integer()
  def part2(filename) do
    read_lines(filename)
    |> Enum.map(&solve(String.graphemes(&1)))
    |> Enum.sum()
  end
end

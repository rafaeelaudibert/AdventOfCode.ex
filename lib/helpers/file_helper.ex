defmodule AdventOfCode.Helpers.File do
  @spec get_path(binary | integer) :: binary
  @doc """
      Returns the AOC input file, for the day passed in
      If it is an integer, it tranforms in an String.t()
      It also properly applies the padding for days with only 1 digit.
  """
  def get_path(day) when is_integer(day), do: get_path(Integer.to_string(day))

  def get_path(day) when is_binary(day) do
    padded_day = String.pad_leading(day, 2, "0")
    Path.join(File.cwd!(), "input/input#{padded_day}.txt")
  end
end

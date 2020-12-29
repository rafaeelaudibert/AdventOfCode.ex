defmodule AdventOfCode.Helpers.Input do
  @spec read_integer(String.t()) :: integer()
  @doc """
    Given a filename, reads the first integer in the file
  """
  def read_integer(filename) do
    read_integers(filename) |> hd()
  end

  @spec read_integers(String.t()) :: [integer()]
  @doc """
    Given a filename, reads every integer in the file
  """
  def read_integers(filename) do
    read_lines(filename) |> Enum.map(&String.to_integer/1)
  end

  @spec read_chunked_lines(String.t(), String.t()) :: [[String.t()]]
  @doc """
    Given a filename, reads every line in the file, and chunks them
    by the separator, with default as an empty line

    ## Examples:

    For the file with the following content:

        abc
        def
        fhi

        abc
        def

    Returns `[["abc", "def", "fhi"] ["abc", "def"]]`
  """
  def read_chunked_lines(filename, separator \\ "") do
    read_lines(filename)
    |> Enum.chunk_by(&(&1 == separator))
    |> Enum.filter(&(Enum.at(&1, 0) != separator))
  end

  @spec read_line(String.t()) :: String.t()
  @doc """
    Given a filename, read the very first line in the file,
    and returns it. A line is understood as ended by a `\\n`
    character.
  """
  def read_line(filename), do: read_lines(filename) |> List.first()

  @spec read_lines(String.t()) :: [String.t()]
  @doc """
    Given a filename, reads every line in the file, and returns
    a list of strings, according to each of the file lines
    A line is counted as separated by a `\\n` character
  """
  def read_lines(filename) do
    with {:ok, file} <- File.read(filename),
         do: file |> String.replace("\r", "") |> String.split("\n")
  end
end

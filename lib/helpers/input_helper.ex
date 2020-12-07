defmodule AdventOfCode.Helpers.Input do
    def read_integer(filename) do
        read_integers(filename) |> hd()
    end

    def read_integers(filename) do
        read_lines(filename) |> Enum.map(&String.to_integer/1)
    end

    def read_chunked_lines(filename, separator \\ "") do
        read_lines(filename)
            |> Enum.chunk_by(& &1 == separator)
            |> Enum.filter(& Enum.at(&1, 0) != separator)
    end

    def read_lines(filename) do
        with {:ok, file} <- File.read(filename),
            do: file |> String.replace("\r", "") |> String.split("\n")
    end

end
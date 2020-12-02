defmodule AdventOfCode.Helpers.Input do
    def read_integer(filename) do
        read_integers(filename) |> hd()
    end

    def read_integers(filename) do
        read_lines(filename) |> Enum.map(&String.to_integer/1)
    end

    def read_lines(filename) do
        with {:ok, file} <- File.read(filename),
            do: file |> String.replace("\r", "") |> String.split("\n", trim: true)
    end
end
defmodule TreeCounter do
  def simulate(terrain, slope \\ %{right: 3, down: 1}) do
    line_length = line_length(terrain)

    terrain
    |> Enum.take_every(slope.down)
    |> Enum.reduce(%{trees: 0, offset: 0}, fn line, %{trees: trees, offset: offset} ->
      trees = if String.at(line, offset) == "#", do: trees + 1, else: trees
      offset = offset + slope.right
      offset = if offset > line_length - 1, do: offset - line_length, else: offset
      %{trees: trees, offset: offset}
    end)
    |> Map.get(:trees)
  end

  defp line_length(terrain) do
    terrain
    |> List.first()
    |> String.length()
  end
end

terrain =
  "puzzle.txt"
  |> File.read!()
  |> String.split("\n", trim: true)

terrain
|> TreeCounter.simulate()
|> IO.puts()

[
  %{right: 1, down: 1},
  %{right: 3, down: 1},
  %{right: 5, down: 1},
  %{right: 7, down: 1},
  %{right: 1, down: 2}
]
|> Enum.map(&(TreeCounter.simulate(terrain, &1)))
|> Enum.reduce(1, &*/2)
|> IO.puts()

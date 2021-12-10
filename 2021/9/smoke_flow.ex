rows =
  # "example.txt"
  "input.txt"
  |> File.read!()
  |> String.split("\n", trim: true)
  |> Enum.with_index()

coordinates =
  rows
  |> Enum.reduce(%{}, fn {row, x}, acc ->
    row
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index()
    |> Enum.map(fn {digit, y} ->
      {{x, y}, digit}
    end)
    |> Enum.into(acc)
  end)

adjacent_values = fn {x, y} ->
  [
    coordinates[{x - 1, y}],
    coordinates[{x + 1, y}],
    coordinates[{x, y + 1}],
    coordinates[{x, y - 1}]
  ]
end

coordinates
|> Enum.filter(fn {{x, y}, value} ->
  adjacent_values = adjacent_values.({x, y})
  value not in adjacent_values && Enum.min([value | adjacent_values]) == value
end)
|> Enum.map(fn {_, value} -> value + 1 end)
|> Enum.sum()
|> IO.inspect(label: "Part 1")

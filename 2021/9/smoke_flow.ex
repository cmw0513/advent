rows =
  "example.txt"
  # "input.txt"
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

defmodule SmokeFlow do
  def adjacent_values(coordinates, point) do
    point
    |> adjacent_coordinates()
    |> Enum.map(fn point -> coordinates[point] end)
  end

  def adjacent_coordinates({x, y}) do
    [
      {x - 1, y},
      {x + 1, y},
      {x, y + 1},
      {x, y - 1}
    ]
  end

  def adjacent_basin_coordinates(coordinates, point) do
    point
    |> adjacent_coordinates()
    |> Enum.reject(fn {x, y} -> coordinates[{x, y}] in [nil, 9] end)
  end

  def basin_coordinates(coordinates, point) do
    adjacent_basin_coordinates(coordinates, point)
    |> Enum.map_reduce([])
  end
end

# Enum.reduce(coordinates, [], fn {point, _value}, acc ->
#   if point in List.flatten(acc),
#     do: acc,
#     else: [SmokeFlow.adjacent_basin_coordinates(coordinates, point) | acc]
# end)
# |> IO.inspect

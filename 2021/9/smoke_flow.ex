defmodule SmokeFlow do
  def low_points(coordinate_heights) do
    Enum.filter(coordinate_heights, fn {point, height} ->
      point
      |> adjacent_heights(coordinate_heights)
      |> Enum.all?(&(&1 > height))
    end)
  end

  def find_basin(point, coordinate_heights, basin \\ []) do
    if point in basin or coordinate_heights[point] in [nil, 9] do
      basin
    else
      point
      |> adjacent_coordinates()
      |> Enum.reduce([point | basin], &find_basin(&1, coordinate_heights, &2))
    end
  end

  def adjacent_coordinates({x, y}) do
    [
      {x - 1, y},
      {x + 1, y},
      {x, y + 1},
      {x, y - 1}
    ]
  end

  def adjacent_heights(point, coordinates) do
    point
    |> adjacent_coordinates()
    |> Enum.map(&(coordinates[&1]))
  end
end

coordinate_heights =
  # "example.txt"
  "input.txt"
  |> File.read!()
  |> String.split("\n", trim: true)
  |> Enum.with_index()
  |> Enum.reduce(%{}, fn {row, x}, acc ->
    row
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index()
    |> Enum.map(fn {height, y} -> {{x, y}, height} end)
    |> Enum.into(acc)
  end)

coordinate_heights
|> SmokeFlow.low_points()
|> Enum.map(fn {_, value} -> value + 1 end)
|> Enum.sum()
|> IO.inspect(label: "Part 1")

coordinate_heights
|> SmokeFlow.low_points()
|> Enum.map(fn {point, _} ->
  point
  |> SmokeFlow.find_basin(coordinate_heights, [])
  |> length()
end)
|> Enum.sort(:desc)
|> Enum.take(3)
|> Enum.product()
|> IO.inspect(label: "Part 2")

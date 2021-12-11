defmodule Octopus do
  def flash(initial_grid) do
    initial_grid
    |> Enum.filter(fn {_octopus, energy} -> energy && energy > 9 end)
    |> Enum.reduce(initial_grid, fn {octopus, _energy}, grid ->
      grid = %{grid | octopus => nil}

      octopus
      |> adjacent_octopi()
      |> Enum.reduce(grid, fn octopus, acc ->
        case acc[octopus] do
          nil -> acc
          energy -> %{acc | octopus => energy + 1}
        end
      end)
    end)
    |> then(fn grid ->
      if Enum.any?(grid, fn {_octopus, energy} -> energy && energy > 9 end) do
        flash(grid)
      else
        grid
      end
    end)
  end

  def adjacent_octopi({x, y}) do
    [
      {x - 1, y},
      {x + 1, y},
      {x, y + 1},
      {x, y - 1},
      {x - 1, y - 1},
      {x + 1, y + 1},
      {x - 1, y + 1},
      {x + 1, y - 1}
    ]
  end
end

grid =
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

Enum.reduce(1..100, {grid, 0}, fn _step, {grid, flashes} ->
  new_grid =
    grid
    |> Enum.into(%{}, fn {octopus, energy} -> {octopus, energy + 1} end)
    |> Octopus.flash()
    |> Enum.map(fn
      {octopus, nil} -> {octopus, 0}
      other -> other
    end)

  {new_grid, flashes + Enum.count(new_grid, fn {_, energy} -> energy == 0 end)}
end)
|> elem(1)
|> IO.inspect(label: "part 1")

Enum.reduce_while(1..1000, grid, fn step, grid ->
  new_grid =
    grid
    |> Enum.into(%{}, fn {octopus, energy} -> {octopus, energy + 1} end)
    |> Octopus.flash()
    |> Enum.map(fn
      {octopus, nil} -> {octopus, 0}
      other -> other
    end)

  if Enum.all?(new_grid, fn {_, energy} -> energy == 0 end),
    do: {:halt, step},
    else: {:cont, new_grid}
end)
|> IO.inspect(label: "part 2")

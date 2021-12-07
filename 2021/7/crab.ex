positions =
  "puzzle.txt"
  |> File.read!()
  |> String.replace("\n", "")
  |> String.split(",")
  |> Enum.map(&String.to_integer/1)

{min, max} = Enum.min_max(positions)

min..max
|> Enum.map(fn target ->
  Enum.reduce(positions, 0, fn position, total -> total + abs(target - position) end)
end)
|> Enum.min()
|> IO.inspect(label: "Part 1")

min..max
|> Enum.map(fn target ->
  Enum.reduce(positions, 0, fn position, total ->
    total + Range.size(target..position) * (target + position) / 2
  end)
end)
|> Enum.min()
|> round()
|> IO.inspect(label: "Part 2")

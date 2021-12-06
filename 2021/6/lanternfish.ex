lanternfish =
  "input.txt"
  |> File.read!()
  |> String.replace_trailing("\n", "")
  |> String.split(",")
  |> Enum.map(&String.to_integer/1)

Enum.reduce(1..80, lanternfish, fn _x, lanternfish ->
  Enum.flat_map(lanternfish, fn
    0 -> [6, 8]
    y -> [y - 1]
  end)
end)
|> length()
|> IO.inspect(label: "Part 1")

lanternfish_frequencies =
  0..8
  |> Enum.into(%{}, fn x -> {x, 0} end)
  |> Map.merge(Enum.frequencies(lanternfish))

Enum.reduce(1..256, lanternfish_frequencies, fn _x, frequencies ->
  %{
    0 => frequencies[1],
    1 => frequencies[2],
    2 => frequencies[3],
    3 => frequencies[4],
    4 => frequencies[5],
    5 => frequencies[6],
    6 => frequencies[7] + frequencies[0],
    7 => frequencies[8],
    8 => frequencies[0]
  }
end)
|> Enum.map(&elem(&1, 1))
|> Enum.sum()
|> IO.inspect(label: "Part 2")

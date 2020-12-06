"puzzle.txt"
|> File.read!()
|> String.split("\n\n", trim: true)
|> Enum.map(fn group_answers ->
  group_answers
  |> String.replace("\n", "")
  |> String.graphemes()
  |> Enum.uniq()
  |> Enum.count()
end)
|> Enum.reduce(&+/2)
|> IO.inspect()

"puzzle.txt"
|> File.read!()
|> String.split("\n\n", trim: true)
|> Enum.map(fn group_answers ->
  group_count =
    group_answers
    |> String.split("\n", trim: true)
    |> Enum.count()

  group_answers
  |> String.replace("\n", "", trim: true)
  |> String.graphemes()
  |> Enum.frequencies()
  |> Enum.count(fn {_letter, frequency} -> frequency == group_count end)
end)
|> Enum.reduce(&+/2)
|> IO.inspect()

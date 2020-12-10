joltage_ratings =
  "puzzle.txt"
  |> File.read!()
  |> String.split("\n", trim: true)
  |> Enum.map(&String.to_integer/1)
  |> Enum.sort()
  |> IO.inspect()

%{single_jolt_jumps: single_jolt_jumps, triple_jolt_jumps: triple_jolt_jumps} =
  joltage_ratings
  |> Enum.reduce(%{last_joltage: 0, single_jolt_jumps: 0, triple_jolt_jumps: 1}, fn joltage, acc ->
    case joltage - acc[:last_joltage] do
      1 -> Map.merge(acc, %{last_joltage: joltage, single_jolt_jumps: acc[:single_jolt_jumps] + 1})
      2 -> Map.merge(acc, %{last_joltage: joltage})
      3 -> Map.merge(acc, %{last_joltage: joltage, triple_jolt_jumps: acc[:triple_jolt_jumps] + 1})
    end
  end)

IO.inspect(single_jolt_jumps * triple_jolt_jumps)

[0 | joltage_ratings]
|> Enum.with_index()
|> Enum.chunk_by(fn {joltage, index} ->
  IO.inspect(joltage, label: "jolt")
  next_joltage = Enum.at(joltage_ratings, index) |> IO.inspect(label: "next") || 0
  next_joltage - joltage == 3
end)
|> IO.inspect()
# |> Enum.reduce([]}, fn joltage, acc ->
#   joltage
# end)

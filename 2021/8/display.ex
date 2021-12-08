defmodule Display do
  def to_mapset(signal_pattern) do
    signal_pattern
    |> String.codepoints()
    |> MapSet.new()
  end

  def generate_key(sets) do
    key = %{
      "1" => find_by_size(sets, 2),
      "4" => find_by_size(sets, 4),
      "7" => find_by_size(sets, 3),
      "8" => find_by_size(sets, 7)
    }
    sets = sets -- [key["1"], key["4"], key["7"], key["8"]]
    key = Map.put(key, "3", Enum.find(sets, &(MapSet.size(&1) == 5 && MapSet.subset?(key["7"], &1))))
    sets = List.delete(sets, key["3"])
    key = Map.put(key, "9", MapSet.union(key["3"], key["4"]))
    sets = List.delete(sets, key["9"])
    key = Map.put(key, "5", Enum.find(sets, &(MapSet.size(&1) == 5 && MapSet.subset?(&1, key["9"]))))
    sets = List.delete(sets, key["5"])
    key = Map.put(key, "0", Enum.find(sets, &(MapSet.subset?(key["1"], &1))))
    sets = List.delete(sets, key["0"])
    key = Map.put(key, "2", Enum.find(sets, &(MapSet.size(&1) == 5)))
    sets = List.delete(sets, key["2"])
    Map.put(key, "6", List.first(sets))
  end

  defp find_by_size(sets, size) do
    Enum.find(sets, &(MapSet.size(&1) == size))
  end

  def output_value(digits, key) do
    digits
    |> Enum.map(fn digit ->
      key
      |> Enum.find(fn {_d, v} -> v == to_mapset(digit) end)
      |> elem(0)
    end)
    |> Enum.join()
    |> String.to_integer()
  end
end

notes =
  "input.txt"
  |> File.read!()
  |> String.split("\n", trim: true)
  |> Enum.map(&String.split(&1, " | "))

notes
|> Enum.reduce(0, fn [_, digits], total ->
  digits
  |> String.split()
  |> Enum.count(fn digit -> String.length(digit) in [2, 3, 4, 7] end)
  |> Kernel.+(total)
end)
|> IO.inspect(label: "Part 1")

Enum.map(notes, fn [signal_pattern_string, output_string] ->
  key =
    signal_pattern_string
    |> String.split()
    |> Enum.map(&Display.to_mapset/1)
    |> Display.generate_key()

  output_string
  |> String.split()
  |> Display.output_value(key)
end)
|> Enum.sum()
|> IO.inspect(label: "Part 2")

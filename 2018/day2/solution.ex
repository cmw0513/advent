defmodule Box do
  defp ids do
    File.read!("puzzle.txt")
    |> String.split("\n")
    # ["abcdef", "bababc", "abbcde", "abcccd", "aabcdd", "abcdee", "ababab"]
  end

  def find_checksum do
    ids_with_letter_count(2) * ids_with_letter_count(3)
  end

  defp ids_with_letter_count(count) do
    ids()
    |> Enum.map(fn id -> 
      letter_counts(id)  
      |> Enum.member?(count)
    end)
    |> Enum.count(fn x -> x == true end)
  end

  defp letter_counts(id) do
    id
    |> String.graphemes
    |> Enum.group_by(fn x -> x end)
    |> Map.values
    |> Enum.map(fn x -> Enum.count(x) end)
  end
end

Box.find_checksum
|> IO.puts

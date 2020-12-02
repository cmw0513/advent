"puzzle.txt"
  |> File.read!()
  |> String.split("\n", trim: true)
  |> Enum.count(fn password_line ->
    [letter_count_min, letter_count_max, letter, password] =
      password_line
      |> String.replace(":", "")
      |> String.replace("-", " ")
      |> String.split(" ")

    range = Range.new(String.to_integer(letter_count_min), String.to_integer(letter_count_max))

    letter_count =
      password
      |> String.graphemes()
      |> Enum.count(&(&1 == letter))

    Enum.member?(range, letter_count)
  end)
  |> IO.puts()

"puzzle.txt"
|> File.read!()
|> String.split("\n", trim: true)
|> Enum.count(fn password_line ->
  [first_index, second_index, letter, password] =
    password_line
    |> String.replace(":", "")
    |> String.replace("-", " ")
    |> String.split(" ")

  letters = String.graphemes(password)
  letter_in_first_index = Enum.at(letters, String.to_integer(first_index) - 1)
  letter_in_second_index = Enum.at(letters, String.to_integer(second_index) - 1)

  case {letter_in_first_index, letter_in_second_index} do
    {^letter, ^letter} -> false
    {^letter, _} -> true
    {_, ^letter} -> true
    _ -> false
  end
end)
|> IO.puts()

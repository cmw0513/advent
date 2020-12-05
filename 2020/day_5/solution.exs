defmodule BoardingPass do
  def calculate_seat_id({row, seat}) do
    calculate_row(row) * 8 + calculate_seat(seat)
  end

  def calculate_row(row) do
    String.graphemes(row)
    |> Enum.reduce(Enum.to_list(0..127), fn letter, range ->
      {front_half, back_half} = Enum.split(range, round(Enum.count(range) / 2))
      if letter == "B",
       do: back_half,
       else: front_half
    end)
    |> List.first()
  end

  def calculate_seat(seat) do
    String.graphemes(seat)
    |> Enum.reduce(Enum.to_list(0..7), fn letter, range ->
      {front_half, back_half} = Enum.split(range, round(Enum.count(range) / 2))
      if letter == "R",
       do: back_half,
       else: front_half
    end)
    |> List.first()
  end
end

boarding_passes =
  "puzzle.txt"
  |> File.read!()
  |> String.split("\n", trim: true)

boarding_passes
|> Enum.map(&String.split_at(&1, 7))
|> Enum.sort(fn {row1, seat1}, {row2, seat2} ->
  if row1 == row2,
    do: seat1 >= seat2,
    else: row1 <= row2
end)
|> List.first()
|> BoardingPass.calculate_seat_id()
|> IO.inspect()

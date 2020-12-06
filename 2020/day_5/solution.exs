defmodule BoardingPass do
  def order_by_seat_id(boarding_passes) do
    Enum.sort(boarding_passes, fn {row1, seat1}, {row2, seat2} ->
      if row1 == row2,
        do: seat1 >= seat2,
        else: row1 <= row2
    end)
  end

  def seat_id({row, seat}), do: row_number(row) * 8 + seat_number(seat)

  def find_missing_seat_id({row, seats}) do
    [seat_id] = all_seat_ids_in_row(row) -- Enum.map(seats, &seat_id/1)
    seat_id
  end

  defp all_seat_ids_in_row(row) do
    row_value = row_number(row) * 8
    Enum.to_list(row_value..(row_value + 7))
  end

  defp row_number(row), do: calculate_number(row, 0..127, "B")

  defp seat_number(seat), do: calculate_number(seat, 0..7, "R")

  defp calculate_number(binary_partition_string, range, upper_half_letter) do
    binary_partition_string
    |> String.graphemes()
    |> Enum.reduce(Enum.to_list(range), fn letter, possible_numbers ->
      {lower_half, upper_half} = Enum.split(possible_numbers, round(Enum.count(possible_numbers) / 2))
      if letter == upper_half_letter, do: upper_half, else: lower_half
    end)
    |> List.first()
  end
end

boarding_passes =
  "puzzle.txt"
  |> File.read!()
  |> String.split("\n", trim: true)
  |> Enum.map(&String.split_at(&1, 7))

boarding_passes
|> BoardingPass.order_by_seat_id()
|> List.first()
|> BoardingPass.seat_id()
|> IO.inspect()

boarding_passes
|> Enum.group_by(fn {row, _seat} -> row end)
|> Enum.filter(fn {_row, seats} -> Enum.count(seats) != 8 end)
|> Enum.at(1)
|> BoardingPass.find_missing_seat_id()
|> IO.inspect()

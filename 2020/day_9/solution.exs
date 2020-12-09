numbers =
  "puzzle.txt"
  |> File.read!()
  |> String.split("\n", trim: true)
  |> Enum.map(&String.to_integer/1)

defmodule Summer do
  def find_invalid_number(numbers, preamble_length) do
    preamble = Enum.take(numbers, preamble_length)
    number = Enum.at(numbers, preamble_length)
    if sum_possible?(preamble, number) do
      numbers
      |> Enum.drop(1)
      |> find_invalid_number(preamble_length)
    else
      number
    end
  end

  def sum_possible?(preamble, number) do
    Enum.any?(preamble, fn n -> (number - n) in (preamble -- [n]) end)
  end

  def find_encryption_weakness(numbers, invalid_number) do
    case find_initial_sum_range(numbers, invalid_number) do
      nil ->
        numbers
        |> Enum.drop(1)
        |> find_encryption_weakness(invalid_number)

      range ->
        Enum.min(range) + Enum.max(range)
    end
  end

  def find_initial_sum_range(numbers, goal) do
    Enum.reduce_while(numbers, [], fn number, summed_numbers ->
      new_summed_numbers = [number | summed_numbers]
      case goal - Enum.sum(new_summed_numbers) do
        0 -> {:halt, new_summed_numbers}
        difference when difference < 0 -> {:halt, nil}
        _positive_difference -> {:cont, new_summed_numbers}
      end
    end)
  end
end

invalid_number = Summer.find_invalid_number(numbers, 25) |> IO.inspect(label: "invalid number")

numbers
|> Summer.find_encryption_weakness(invalid_number)
|> IO.inspect(label: "encryption weakness")

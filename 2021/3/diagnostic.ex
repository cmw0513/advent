defmodule Diagnostic do
  def numbers(file \\ "report.txt") do
    file
    |> File.stream!()
    |> Enum.map(&String.trim/1)
  end

  def bit_length(numbers) do
    numbers
    |> List.first()
    |> String.length()
  end

  def gamma_rate(numbers \\ numbers()) do
    0..bit_length(numbers) - 1
    |> Enum.map(&(most_common_bit(numbers, &1)))
    |> Enum.join()
    |> String.to_integer(2)
  end

  def epsilon_rate(numbers \\ numbers()) do
    0..bit_length(numbers) - 1
    |> Enum.map(&(least_common_bit(numbers, &1)))
    |> Enum.join()
    |> String.to_integer(2)
  end

  def most_common_bit(numbers, position) do
    numbers
    |> Enum.frequencies_by(&String.at(&1, position))
    |> then(fn bit_frequencies ->
      if bit_frequencies["0"] > bit_frequencies["1"], do: "0", else: "1"
    end)
  end

  def least_common_bit(numbers, position) do
    numbers
    |> Enum.frequencies_by(&String.at(&1, position))
    |> then(fn bit_frequencies ->
      if bit_frequencies["0"] <= bit_frequencies["1"], do: "0", else: "1"
    end)
  end

  def oxygen_generator_rating(numbers \\ numbers()) do
    0..bit_length(numbers) - 1
    |> Enum.reduce_while(numbers, fn position, remaining_numbers ->
      case numbers_with_bit_at(&most_common_bit/2, remaining_numbers, position) do
        [last_number] ->
          {:halt, last_number}

        numbers ->
          {:cont, numbers}
      end
    end)
    |> String.to_integer(2)
  end

  def co2_scrubber_rating(numbers \\ numbers()) do
    0..bit_length(numbers) - 1
    |> Enum.reduce_while(numbers, fn position, remaining_numbers ->
      case numbers_with_bit_at(&least_common_bit/2, remaining_numbers, position) do
        [last_number] ->
          {:halt, last_number}

        numbers ->
          {:cont, numbers}
      end
    end)
    |> String.to_integer(2)
  end

  def numbers_with_bit_at(bit_function, numbers, position) do
    bit = bit_function.(numbers, position)
    Enum.filter(numbers, fn number -> String.at(number, position) == bit end)
  end

  def power_consumption(numbers \\ numbers()) do
    gamma_rate(numbers) * epsilon_rate(numbers)
  end

  def life_support_rating(numbers \\ numbers()) do
    oxygen_generator_rating(numbers) * co2_scrubber_rating(numbers)
  end
end

IO.puts("Part 1")
IO.puts(Diagnostic.power_consumption())

IO.puts("Part 2")
IO.puts(Diagnostic.life_support_rating())

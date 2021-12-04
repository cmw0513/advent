defmodule Bingo do
  def subsystem(file \\ "system.txt") do
    [numbers | cards] =
      file
      |> File.read!()
      |> String.split("\n\n")

    cards =
      cards
      |> Enum.map(fn card ->
        card
        |> String.split("\n", trim: true)
        |> Enum.map(&String.split/1)
      end)

    {String.split(numbers, ","), cards}
  end

  def play_to_win({numbers, cards}) do
    Enum.reduce_while(numbers, cards, fn number, cards ->
      marked_cards = Enum.map(cards, &mark_number(&1, number))
      case Enum.find(marked_cards, &winner?/1) do
        nil -> {:cont, marked_cards}
        winner -> {:halt, {winner, number}}
      end
    end)
  end

  def play_to_lose({numbers, cards}) do
    Enum.reduce_while(numbers, cards, fn number, cards ->
      marked_cards = Enum.map(cards, &mark_number(&1, number))
      case Enum.reject(marked_cards, &winner?/1) do
        [loser] -> {:halt, play_to_win({numbers, [loser]})}
        remaining_cards -> {:cont, remaining_cards}
      end
    end)
  end

  def score({card, winning_number}) do
    sum =
      card
      |> List.flatten()
      |> Enum.filter(&(&1))
      |> Enum.map(&String.to_integer/1)
      |> Enum.sum()

    sum * String.to_integer(winning_number)
  end

  def mark_number(card, number) do
    Enum.map(card, fn card_row ->
      Enum.map(card_row, fn board_number ->
        unless board_number == number, do: board_number
      end)
    end)
  end

  def winner?(card) do
    Enum.any?(card, &bingo_row?/1) || Enum.any?(0..4, &bingo_column?(card, &1))
  end

  def bingo_row?(row), do: not Enum.any?(row)

  def bingo_column?(card, index), do: not Enum.any?(card, &Enum.at(&1, index))
end

Bingo.subsystem()
|> Bingo.play_to_win()
|> Bingo.score()
|> IO.inspect(label: "Part 1")

Bingo.subsystem()
|> Bingo.play_to_lose()
|> Bingo.score()
|> IO.inspect(label: "Part 2")

defmodule Dive do
  def commands(file_name) do
    file_name
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, " "))
    |> Stream.map(fn [direction, value] -> {direction, String.to_integer(value)} end)
  end

  def move({direction, value}, {depth, horizontal_position}) do
    case direction do
      "forward" -> {depth, horizontal_position + value}
      "down" -> {depth + value, horizontal_position}
      "up" -> {depth - value, horizontal_position}
    end
  end

  def move({direction, value}, {depth, horizontal_position, aim}) do
    case direction do
      "forward" -> {depth + (value * aim), horizontal_position + value, aim}
      "down" -> {depth, horizontal_position, aim + value}
      "up" -> {depth, horizontal_position, aim - value}
    end
  end

  def product({depth, horizontal_position}), do: depth * horizontal_position
  def product({depth, horizontal_position, _aim}), do: product({depth, horizontal_position})
end

"commands.txt"
|> Dive.commands()
|> Enum.reduce({0, 0}, &Dive.move/2)
|> Dive.product()
|> IO.inspect(label: "Part 1")

"commands.txt"
|> Dive.commands()
|> Enum.reduce({0, 0, 0}, &Dive.move/2)
|> Dive.product()
|> IO.inspect(label: "Part 2")

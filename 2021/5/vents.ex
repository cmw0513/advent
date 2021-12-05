defmodule Vents do
  def lines do
    "puzzle.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    line
    |> String.split(" -> ", trim: true)
    |> Enum.map(fn coordinate ->
      coordinate
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def produce_diagram(lines) do
    Enum.reduce(lines, [], &mark_line(&2, &1))
  end

  def mark_line(diagram, [[x, y1], [x, y2]]) do
    Enum.map(y1..y2, &([x, &1])) ++ diagram
  end
  def mark_line(diagram, [[x1, y], [x2, y]]) do
    Enum.map(x1..x2, &([&1, y])) ++ diagram
  end
  def mark_line(diagram, [[x1, y1], [x2, y2]]) do
    x1..x2
    |> Enum.zip(y1..y2)
    |> Enum.map(fn {x, y} -> [x, y] end)
    |> Kernel.++(diagram)
  end
end

Vents.lines
|> Vents.produce_diagram()
|> Enum.frequencies()
|> Enum.group_by(&elem(&1, 1), &elem(&1, 0))
|> Map.drop([1])
|> Enum.map(&elem(&1, 1))
|> Enum.map(&length/1)
|> Enum.sum()
|> IO.inspect()

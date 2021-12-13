# "example.txt"
[dots, folds] =
  "input.txt"
  |> File.read!()
  |> String.split("\n\n", trim: true)
  |> Enum.map(&String.split(&1, ["\n", ","], trim: true))

paper =
  dots
  |> Enum.map(&String.to_integer/1)
  |> Enum.chunk_every(2)

instructions =
  folds
  |> Enum.map(fn instruction ->
    instruction
    |> String.replace_leading("fold along ", "")
    |> String.split("=")
    |> then(fn [direction, row] -> {direction, String.to_integer(row)} end)
  end)

defmodule Manual do
  def fold(instruction, paper) do
    paper
    |> Enum.map(&new_dot(&1, instruction))
    |> Enum.uniq()
  end

  defp new_dot([x, y], {"x", column}) when x > column, do: [2 * column - x, y]
  defp new_dot([x, y], {"y", row}) when y > row, do: [x, 2 * row - y]
  defp new_dot(dot, _), do: dot
end

instructions
|> List.first()
|> Manual.fold(paper)
|> length()
|> IO.inspect(label: "Part 1")

IO.puts("Part 2:")
folded = Enum.reduce(instructions, paper, &Manual.fold/2)

max_y =
  folded
  |> Enum.map(&Enum.at(&1, 1))
  |> Enum.max()

max_x =
  folded
  |> Enum.map(&Enum.at(&1, 0))
  |> Enum.max()

for y <- 0..max_y do
  IO.puts(for x <- 0..max_x, do: if([x, y] in folded, do: '#', else: '.'))
end

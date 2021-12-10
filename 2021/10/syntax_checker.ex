defmodule SyntaxChecker do
  @closers [")", "]", "}", ">"]
  @illegal_points %{")" => 3, "]" => 57, "}" => 1197, ">" => 25137}
  @completion_values %{")" => 1, "]" => 2, "}" => 3, ">" => 4}

  def validate_line(line), do: validate_line(line, [])
  def validate_line([value | chars], []), do: validate_line(chars, [closer(value)])
  def validate_line([value | chars], [value | rest]), do: validate_line(chars, rest)
  def validate_line([value | _], _) when value in @closers, do: {:invalid, @illegal_points[value]}
  def validate_line([value | chars], rest), do: validate_line(chars, [closer(value) | rest])
  def validate_line([], to_complete) do
    {:incomplete, Enum.reduce(to_complete, 0, fn symbol, acc -> acc * 5 + @completion_values[symbol] end)}
  end

  def closer(opener) do
    case opener do
      "(" -> ")"
      "[" -> "]"
      "{" -> "}"
      "<" -> ">"
    end
  end
end

validated_lines =
  # "example.txt"
  "input.txt"
  |> File.read!()
  |> String.split("\n", trim: true)
  |> Enum.map(fn line ->
    line
    |> String.codepoints()
    |> SyntaxChecker.validate_line()
  end)

validated_lines
|> Enum.map(fn
  {:invalid, value} -> value
  _ -> 0
end)
|> Enum.sum()
|> IO.inspect(label: "Part 1")

validated_lines
|> Enum.reduce([], fn
  {:incomplete, value}, acc -> [value | acc]
  _, acc -> acc
 end)
|> Enum.sort()
|> then(fn list ->
  Enum.at(list, floor(length(list)/2))
end)
|> IO.inspect(label: "Part 2")

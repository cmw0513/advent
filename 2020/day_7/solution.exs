defmodule Luggage do
  def bag_colors_containing(rules, bag_color) do
    direct_container_colors =
      rules
      |> Enum.filter(fn {_outer_bag_color, inner_bag_colors} -> bag_color in inner_bag_colors end)
      |> Enum.into(%{})
      |> Map.keys()

    direct_container_colors ++ Enum.map(direct_container_colors, &(bag_colors_containing(rules, &1)))
    |> List.flatten()
    |> Enum.uniq()
  end

  def number_of_bags_contained(_rules, {"other", _}), do: 0
  def number_of_bags_contained(rules, {bag_color, number}) do
    nested =
      rules
      |> Map.get(bag_color)
      |> Enum.map(fn bag -> number * number_of_bags_contained(rules, bag) end)

    [number | nested]
    |> Enum.reduce(&+/2)
  end
  def number_of_bags_contained(rules, color), do: number_of_bags_contained(rules, {color, 1}) - 1
end

rules =
  "puzzle.txt"
  |> File.read!()
  |> String.split("\n", trim: true)
  |> Enum.map(fn rule ->
    [outer_bag, inner_bags] = String.split(rule, " bags contain")
    {outer_bag,
      inner_bags
      |> String.trim()
      |> String.replace(~r/\d /, "")
      |> String.split(~r/ bags?(, |.)/)
      |> Enum.reject(fn bag -> bag == "" end)}
  end)

Luggage.bag_colors_containing(rules, "shiny gold")
|> Enum.count()
|> IO.inspect()

rules =
  "puzzle.txt"
  |> File.read!()
  |> String.split("\n", trim: true)
  |> Enum.map(fn rule ->
    [outer_bag, inner_bags] = String.split(rule, " bags contain")
    {outer_bag,
      inner_bags
      |> String.trim()
      |> String.split(~r/ bags?(, |.)/)
      |> Enum.reject(fn bag -> bag == "" end)
      |> Enum.map(fn inner_rule ->
        [count, color] = String.split(inner_rule, " ", parts: 2)
        case Integer.parse(count) do
          {integer, ""} -> {color, integer}
          _ -> {color, 0}
        end
      end)
      |> Enum.into(%{})}
  end)
  |> Enum.into(%{})

Luggage.number_of_bags_contained(rules, "shiny gold")
|> IO.inspect()

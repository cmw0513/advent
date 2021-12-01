defmodule Navigator do
  def directions do
    "example.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn direction ->
      {action, value} = String.split_at(direction, 1)
      {action, String.to_integer(value)}
    end)
  end

  def move(direction, {x, y}, value) do
    case direction do
      "N" -> {x, y + value}
      "S" -> {x, y - value}
      "E" -> {x + value, y}
      "W" -> {x - value, y}
    end
  end

  def turn(facing, action, degrees) do
    IO.inspect(degrees, label: "degrees")
    pivots = Integer.mod(trunc(degrees / 90), 4) |> IO.inspect(label: "pivots")
    directions = ~w(N E S W)
    current_face_at = Enum.find_index(directions, &(&1 == facing)) |> IO.inspect(label: "current index")
    if action == "R",
      do: Enum.at(directions, Integer.mod(current_face_at + pivots, 4)),
      else: Enum.at(directions, Integer.mod(current_face_at - pivots, 4))
  end
end

{_facing, {x, y}} =
  Enum.reduce(Navigator.directions, {"E", {0, 0}}, fn {action, value}, {facing, coordinates} ->
    status =
      case action do
        action when action in ~w(N S E W) ->
          {facing, Navigator.move(action, coordinates, value)}

        "F" ->
          {facing, Navigator.move(facing, coordinates, value)}

        _ ->
          {Navigator.turn(facing, action, value), coordinates}
      end

    IO.inspect(status)
  end)

  IO.puts(abs(x) + abs(y))

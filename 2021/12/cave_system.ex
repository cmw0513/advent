defmodule CaveSystem do
  def add_connection(system, "end", _), do: system
  def add_connection(system, _, "start"), do: system
  def add_connection(system, cave1, cave2) do
    if system[cave1] do
      Map.update!(system, cave1, &([cave2 | &1]))
    else
      Map.put(system, cave1, [cave2])
    end
  end

  def find_paths(system, opts \\ [], start \\ "start", visited \\ []) do
    Enum.reduce(system[start], 0, fn connection, count ->
      cond do
        disallowed_revisit?(connection, visited, opts) ->
          count

        connection == "end" ->
          count + 1

        true ->
          count + find_paths(system, opts, connection, [connection | visited])
      end
    end)
  end

  def disallowed_revisit?(connection, visited, opts) do
    small_cave?(connection)
      && connection in visited
      && (!opts[:revisit_small_cave] || small_cave_already_visited?(visited))
  end

  def small_cave?(cave), do: String.downcase(cave) == cave

  def small_cave_already_visited?(visited) do
    small_caves = Enum.filter(visited, &small_cave?/1)
    small_caves != Enum.uniq(small_caves)
  end
end

system =
  # "example.txt"
  "input.txt"
  |> File.read!()
  |> String.split("\n", trim: true)
  |> Enum.reduce(%{}, fn connection, system ->
    [cave1, cave2] = String.split(connection, "-")

    system
    |> CaveSystem.add_connection(cave1, cave2)
    |> CaveSystem.add_connection(cave2, cave1)
  end)

system
|> CaveSystem.find_paths()
|> IO.inspect(label: "Part 1")

system
|> CaveSystem.find_paths(revisit_small_cave: true)
|> IO.inspect(label: "Part 2")

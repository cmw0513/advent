defmodule Bus do
  def notes do
    "input.txt"
    |> File.read!()
    |> String.split(~r/[\s,]+/, trim: true)
    |> Enum.reject(& &1 == "x")
    |> Enum.map(&String.to_integer/1)
  end

  def offsets do
    "example.txt"
    |> File.read!()
    |> String.split(~r/[\s,]+/, trim: true)
    |> List.delete_at(0)
    |> Enum.with_index()
    |> Keyword.drop(["x"])
    |> Enum.map(fn {bus_id, offset} -> {offset, String.to_integer(bus_id)} end)
  end

  def offset_departure(earliest_departure, offsets) do
    if Enum.all?(offsets, )
  end

  def next_departure(earliest_departure, bus_ids) do
    case Enum.find(bus_ids, fn bus_id -> Integer.mod(earliest_departure, bus_id) == 0 end) do
      nil -> next_departure(earliest_departure + 1, bus_ids)
      bus_id -> {bus_id, earliest_departure}
    end
  end
end

# [earliest_departure | bus_ids] = Bus.notes()
# {bus_id, departure} = Bus.next_departure(earliest_departure, bus_ids)
# IO.inspect((departure - earliest_departure) * bus_id)

IO.inspect(Bus.offsets)

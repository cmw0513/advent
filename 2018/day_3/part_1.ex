defmodule PartOne do
  def claims do
    "puzzle.txt"
    # "example.txt"
    |> File.read!()
    |> String.split(~r{#\d+ @ }, trim: true)
    |> Enum.map(&String.trim/1)
  end

  def overlap_sum do
    all_overlapping_squares()
    |> Enum.uniq
    |> Enum.count
  end

  def get_squares(claim) do
    [location, size] = claim |> String.split(": ")
    [left_edge, top_edge] = location |> String.split(",") |> Enum.map(&String.to_integer/1)
    [width, height] = size |> String.split("x") |> Enum.map(&String.to_integer/1)

    for column <- left_edge + 1..left_edge + width, row <- top_edge + 1..top_edge + height do
      [column, row]
    end
  end

  def all_overlapping_squares do
    [overlaps, _claims] =
      claims()
      |> Enum.reduce([[], []], fn claim, [overlaps, claimed_squares] ->
        squares = get_squares(claim)
        Enum.reduce(squares, [MapSet.new(overlaps), MapSet.new(claimed_squares)], fn square, [overlaps, claimed_squares] ->
          if MapSet.member?(claimed_squares, square) do
            [MapSet.put(overlaps, square), MapSet.new(claimed_squares)]
          else
            [MapSet.new(overlaps), MapSet.put(claimed_squares, square)]
          end
        end)
      end)
    overlaps
  end

  def single_layer_claim do
    overlapping_squares = all_overlapping_squares()
    Enum.reduce_while(claims(), [], fn claim, claimed_squares ->
      case MapSet.size(MapSet.intersection(MapSet.new(get_squares(claim)), overlapping_squares)) > 0 do
        true  -> {:cont, overlapping_squares}
        false -> {:halt, claim}
      end
    end)
  end
end

PartOne.overlap_sum
|> IO.puts

PartOne.single_layer_claim
|> IO.puts

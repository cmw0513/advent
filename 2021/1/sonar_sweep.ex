defmodule SonarSweep do
  def depths(report_file) do
    report_file
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def rolling_depths(depths) do
    depths
    |> Enum.with_index(fn depth, index ->
      if index + 2 < Enum.count(depths) do
        depth + Enum.at(depths, index + 1) + Enum.at(depths, index + 2)
      end
    end)
    |> Enum.reject(&is_nil/1)
  end

  def increase_count(depths) do
    depths
    |> Enum.with_index(fn depth, index ->
      previous_depth = Enum.at(depths, index - 1)

      cond do
        index == 0 -> "N/A - no previous measurement"
        depth < previous_depth -> "decreased"
        depth > previous_depth -> "increased"
        true -> "no change"
      end
    end)
    |> Enum.count(&(&1 == "increased"))
  end
end

# Part 1
"report.txt"
|> SonarSweep.depths()
|> SonarSweep.increase_count()
|> IO.puts()

# Part 2
"report.txt"
|> SonarSweep.depths()
|> SonarSweep.rolling_depths()
|> SonarSweep.increase_count()
|> IO.puts()

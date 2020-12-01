defmodule ExpenseReport do
  def reject_too_high_entries(entries, entries_to_sum \\ 2) do
    {lowest_entries, _rest} =
      entries
      |> Enum.sort()
      |> Enum.split(entries_to_sum - 1)

    Enum.reject(entries, &(&1 > (2020 - Enum.sum(lowest_entries))))
  end

  def find_solution_entry(entries, sum \\ 2020) do
    Enum.find(entries, &(Enum.member?(entries, sum - &1)))
  end
end

entry =
  "expense_report.txt"
  |> File.read!()
  |> String.split("\n", trim: true)
  |> Enum.map(&String.to_integer/1)
  |> ExpenseReport.reject_too_high_entries()
  |> ExpenseReport.find_solution_entry()

IO.puts(entry * (2020 - entry))

entries =
  "expense_report.txt"
  |> File.read!()
  |> String.split("\n", trim: true)
  |> Enum.map(&String.to_integer/1)
  |> ExpenseReport.reject_too_high_entries(3)


{entry1, entry2, entry3} =
  Enum.reduce_while(entries, entries, fn entry1, reduced_entries ->
    case ExpenseReport.find_solution_entry(reduced_entries, (2020 - entry1)) do
      nil -> {:cont, reduced_entries -- [entry1]}
      entry2 -> {:halt, {entry1, entry2, 2020 - entry1 - entry2}}
    end
  end)

IO.puts(entry1 * entry2 * entry3)

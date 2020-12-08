defmodule BootCode do
  def run_instructions(instructions, index \\ 0, acc \\ 0, past_instruction_indexes \\ []) do
    if index in past_instruction_indexes do
      %{acc: acc, index: index, past_instruction_indexes: past_instruction_indexes}
    else
      past_instruction_indexes = [index | past_instruction_indexes]
      case Enum.at(instructions, index) do
        {"nop", _} -> run_instructions(instructions, index + 1, acc, past_instruction_indexes)
        {"acc", argument} -> run_instructions(instructions, index + 1, acc + argument, past_instruction_indexes)
        {"jmp", argument} -> run_instructions(instructions, index + argument, acc, past_instruction_indexes)
        _ -> acc
      end
    end
  end
end

instructions =
  "puzzle.txt"
  |> File.read!()
  |> String.split("\n", trim: true)
  |> Enum.map(&String.split/1)
  |> Enum.map(fn [operation, argument] -> {operation, String.to_integer(argument)} end)

%{acc: acc, index: index, past_instruction_indexes: past_instruction_indexes} = BootCode.run_instructions(instructions) |> IO.inspect

past_instruction_indexes
|> Enum.filter(fn x -> Enum.at(instructions, x) |> elem(0) == "jmp" end)
|> Enum.find_value(fn replacement_index ->
  argument = instructions |> Enum.at(replacement_index) |> elem(1)
  acc =
    instructions
    |> List.replace_at(replacement_index, {"nop", argument})
    |> BootCode.run_instructions()
  unless is_map(acc), do: acc
end)
|> IO.inspect()

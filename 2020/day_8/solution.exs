defmodule BootCode do
  def run_instructions(instructions, index, acc, past_instruction_indexes) do
    if index in past_instruction_indexes do
      acc
    else
      instruction = Enum.at(instructions, index)
      past_instruction_indexes = [index | past_instruction_indexes]
      case instruction do
        {"nop", _} -> run_instructions(instructions, index + 1, acc, past_instruction_indexes)
        {"acc", argument} -> run_instructions(instructions, index + 1, acc + argument, past_instruction_indexes)
        {"jmp", argument} -> run_instructions(instructions, index + argument, acc, past_instruction_indexes)
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

BootCode.run_instructions(instructions, 0, 0, [])
|> IO.inspect

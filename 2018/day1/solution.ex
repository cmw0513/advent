 
defmodule Frequency do
    def find_duplicate(changes, starting, frequency_list) do
        [frequency, frequencies] = 
            Enum.reduce_while(changes, [starting, frequency_list], fn(x, [starting_frequency, frequencies]) -> 
                positive = String.starts_with?(x, "+")
                digit = 
                    String.replace_leading(x, "+", "")
                    |> String.replace_leading("-", "")
                    |> String.to_integer
                frequency = case positive do
                    true  -> starting_frequency + digit
                    false -> starting_frequency - digit
                end
                duplicate =
                    case Enum.member?(frequencies, frequency) do
                        true  -> frequency
                        false -> nil
                    end
                frequencies = 
                    case is_nil(duplicate) do
                        true  -> [frequency | frequencies]
                        false -> nil
                    end
                case is_nil(duplicate) do
                    true -> {:cont, [frequency, frequencies]}
                    false -> {:halt, [duplicate, frequencies]}
                end
            end)
        case is_nil(frequencies) do
            true -> frequency
            false -> find_duplicate(changes, frequency, frequencies)
        end
    end
end

File.read!("input")
|> String.split("\n")
|> Frequency.find_duplicate(0, [])
|> IO.puts

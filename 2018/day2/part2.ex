defmodule Box do
  def ids do
    File.read!("puzzle.txt")
    |> String.split("\n")
  end

  def find_close_ids() do
    find_close_id(ids())
  end
  def find_close_ids(ids) do
    {id, remaining_ids} = List.pop_at(ids, 0)
    id_letters = String.graphemes(id)
    
    matching_id_letters = 
      Enum.reduce_while(0..String.length(id) - 1, nil, fn letter_index, _acc ->
        regular_expression = 
          id_letters
          |> List.replace_at(letter_index, ".")
          |> List.to_string
        
        match = 
          Enum.find(remaining_ids, fn match_id -> 
            String.match?(match_id, ~r/#{regular_expression}/)
          end)

        case is_nil(match) do
          true  -> {:cont, nil}
          false -> {:halt, String.replace(regular_expression, ".", "")} 
        end
      end)

    case is_nil(matching_id_letters) do
      true  -> find_close_id(remaining_ids)
      false -> matching_id_letters 
    end
  end
end

Box.find_close_ids
|> IO.puts
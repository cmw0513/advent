defmodule Passport do
  def fields_valid?(%{
    "byr" => birth_year,
    "iyr" => issue_year,
    "eyr" => expiration_year,
    "hgt" => height,
    "hcl" => hair_color,
    "ecl" => eye_color,
    "pid" => passport_id
  }) do
    valid_year?(birth_year, 1920..2002) &&
      valid_year?(issue_year, 2010..2020) &&
        valid_year?(expiration_year, 2020..2030) &&
          valid_height?(height) &&
            Regex.match?(~r/^#[a-f0-9]{6}$/, hair_color) &&
              eye_color in ~w(amb blu brn gry grn hzl oth) &&
                Regex.match?(~r/^\d{9}$/, passport_id)
  end
  def fields_valid?(_), do: false

  def has_all_required_fields?(%{
    "byr" => _birth_year,
    "iyr" => _issue_year,
    "eyr" => _expiration_year,
    "hgt" => _height,
    "hcl" => _hair_color,
    "ecl" => _eye_color,
    "pid" => _passport_id
  }) do
    true
  end
  def has_all_required_fields?(_), do: false

  defp valid_year?(year, range) do
    if {year, ""} = Integer.parse(year), do: year in range
  end

  defp valid_height?(height) do
    case Regex.run(~r/^(\d+)(\D+)$/, height) do
      [_, height, "cm"] -> String.to_integer(height) in 150..193
      [_, height, "in"] -> String.to_integer(height) in 59..76
      _ -> false
    end
  end

end

passports =
  "puzzle.txt"
  |> File.read!()
  |> String.split("\n\n", trim: true)
  |> Enum.map(fn passport_string ->
    ~r/\s?(\w+):(\S+)/
    |> Regex.scan(passport_string)
    |> Enum.map(fn [_, field, value] -> {field, value} end)
    |> Enum.into(%{})
  end)

passports
|> Enum.count(&Passport.has_all_required_fields?/1)
|> IO.inspect()

passports
|> Enum.count(&Passport.fields_valid?/1)
|> IO.inspect()

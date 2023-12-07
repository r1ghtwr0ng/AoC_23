defmodule Day2 do
  # Read file and pass contents along for solving
  def solve(filename) do
    case File.read(filename) do
      {:ok, data} -> IO.puts("[+] Solution: #{calculate(data)}")

      {:error, err} -> IO.puts("[!] Error while reading #{filename} : #{err}")
    end
  end

  def calculate(data) do
    data
    |> String.trim()
    |> sanitized_split()
    |> Enum.reduce(0, fn game, acc -> handle_game(game) + acc; end)
  end

  def handle_game(game) do # Game iteration
    [id, text] = sanitized_split(game, ":")
    cond do
      check_game(text) ->
        id
        |> String.slice(5..-1)
        |> String.to_integer()

      true -> 0
    end
  end

  def check_game(game) do
    game
    |> sanitized_split(";")
    |> Enum.reduce(true, fn round, acc -> # Round iteration
      round
      |> sanitized_split(",")
      |> check_colors(%{red: 0, green: 0, blue: 0}, %{red: 12, green: 13, blue: 14})
      |> Kernel.&&(acc)
    end)
  end

  def check_colors([], color_map, target) do
    Enum.reduce(color_map, true, fn {key, val}, acc ->
      acc && (target[key] >= val)
    end)
  end

  def check_colors([head | tail], color_map, target) do
    [count, color] = sanitized_split(head, " ")
    new_map = Map.put(color_map, String.to_atom(color), String.to_integer(count))
    check_colors(tail, new_map, target)
  end

  def sanitized_split(text), do: sanitized_split(text, "\n")
  def sanitized_split(text, separator) do
    text
    |> String.split(separator)
    |> Enum.map(&String.trim/1)
  end
end

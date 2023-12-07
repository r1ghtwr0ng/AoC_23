defmodule DayPart1 do
  # Read file and pass contents along for solving
  def solve(filename) do
    case File.read(filename) do
      {:ok, data} -> IO.puts("[+] Solution (part 1): #{calculate(data)}")

      {:error, err} -> IO.puts("[!] Error while reading #{filename} : #{err}")
    end
  end

  defp calculate(data) do
    data
    |> String.trim()
    |> sanitized_split()
    |> Enum.reduce(0, fn game, acc -> handle_game(game) + acc; end)
  end

  defp handle_game(game) do # Game iteration
    [id, text] = sanitized_split(game, ":")
    cond do
      check_game(text) ->
        id
        |> String.slice(5..-1)
        |> String.to_integer()

      true -> 0
    end
  end

  defp check_game(game) do
    game
    |> sanitized_split(";")
    |> Enum.reduce(true, fn round, acc -> # Round iteration
      round
      |> sanitized_split(",")
      |> check_colors(%{red: 0, green: 0, blue: 0}, %{red: 12, green: 13, blue: 14})
      |> Kernel.&&(acc)
    end)
  end

  defp check_colors([], color_map, target) do
    Enum.reduce(color_map, true, fn {key, val}, acc ->
      acc && (target[key] >= val)
    end)
  end

  defp check_colors([head | tail], color_map, target) do
    [count, color] = sanitized_split(head, " ")
    new_map = Map.put(color_map, String.to_atom(color), String.to_integer(count))
    check_colors(tail, new_map, target)
  end

  defp sanitized_split(text), do: sanitized_split(text, "\n")
  defp sanitized_split(text, separator) do
    text
    |> String.split(separator)
    |> Enum.map(&String.trim/1)
  end
end

defmodule Day2Part2 do
  # Read file and pass contents along for solving
  def solve(filename) do
    case File.read(filename) do
      {:ok, data} -> IO.puts("[+] Solution (part 2): #{calculate(data)}")

      {:error, err} -> IO.puts("[!] Error while reading #{filename} : #{err}")
    end
  end

  defp calculate(data) do
    data
    |> String.trim()
    |> sanitized_split("\n")
    |> Enum.reduce(0, fn game, acc -> handle_game(game) + acc; end)
  end

  defp handle_game(game) do # Game iteration
    game
    |> sanitized_split(":")
    |> Enum.at(1)
    |> sanitized_split(";")
    |> calculate_power()
  end

  defp calculate_power(scores, []) do
    Enum.reduce(scores, 1, fn {_color, score}, acc ->
      case Enum.max(score) do
        0 -> acc
        max -> max * acc
      end
    end)
  end
  defp calculate_power(scores, [round | tail]) do
    round
    |> sanitized_split(",")
    |> Enum.reduce(%{}, fn text, acc ->
      [count, color] = sanitized_split(text)
      key = String.to_atom(color)
      value = Map.get(acc, key, []) ++ [String.to_integer(count)]
      Map.put(acc, key, value)
    end)
    |> Map.merge(scores, fn _k, list1, list2 -> list1 ++ list2; end)
    |> calculate_power(tail)
  end
  defp calculate_power(rounds), do: calculate_power(%{}, rounds)

  # Split and trim
  defp sanitized_split(text, separator \\ " ") do
    text
    |> String.split(separator)
    |> Enum.map(&String.trim/1)
  end
end

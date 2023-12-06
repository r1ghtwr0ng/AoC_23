defmodule Day1 do
  # Read file and pass contents along for solving
  def solve(filename) do
    case File.read(filename) do
      {:ok, data} -> IO.puts("[+] Solution: #{sum_solutions(data)}")

      {:error, err} -> IO.puts("[!] Error while reading #{filename} : #{err}")
    end
  end

  # Sum the integer solutions of all words
  defp sum_solutions(data) do
    data
    |> String.trim()
    |> String.downcase()
    |> convert_words() # Part 2 doesn't fucking work, maybe write a decent description of the objective
    |> String.split("\n")
    |> Enum.reduce(0, fn word, acc -> acc + solve_word(word) end)
  end

  # Extract digits from a single words and return int
  def solve_word(text) do
    text
    |> String.replace(~r/[^\d]/, "")
    |> extract_digits()
    |> String.to_integer()
  end

  defp extract_digits(sanitised) do
    first = String.at(sanitised, 0)
    last = String.at(sanitised, -1)

    first <> last
  end

  # Part 2, convert first match of string
  defp convert_words(text) do
    digit_words = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
    regex_pattern = Enum.join(digit_words, "|")

    replaced = replace_digit_words(text, regex_pattern) # Recursively replace the first occurance of a digit-word
    replaced
  end

  defp replace_digit_words(text, regex_pattern) do
    Regex.replace(~r/#{regex_pattern}/, text, fn match ->
      digit_map(match)
    end, global: false)
    |> case do
      ^text -> text
      replaced -> replace_digit_words(replaced, regex_pattern)
    end
  end

  # Part 2
  defp digit_map(word) do
    case word do
      "one" -> "o1e"
      "two" -> "t2o"
      "three" -> "t3ree"
      "four" -> "f4ur"
      "five" -> "f5ve"
      "six" -> "s6x"
      "seven" -> "s7ven"
      "eight" -> "e8ght"
      "nine" -> "n9ne"
      _ -> word
    end
  end
end

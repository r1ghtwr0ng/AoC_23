defmodule Day3Part1 do
  # Read file and pass contents along for solving
  def solve(filename) do
    case File.read(filename) do
      {:ok, data} -> IO.puts("[+] Solution (part 1): #{calculate(data)}")

      {:error, err} -> IO.puts("[!] Error while reading #{filename} : #{err}")
    end
  end
end

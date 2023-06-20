defmodule WordleCli.ConsoleApp do
  import WordleCli.Wordle, only: [init_wordle_game: 0]

  def main(_) do
    display_instruction()
    init_wordle_game() |> process_input()
  end

  defp process_input(process_turn) when is_function(process_turn) do
    input_guess()
    |> process_turn.()
    |> process_output()
  end

  defp process_output({:guess, guess, try_count, result, process_turn}) do
    convert_guess_result(guess, result)
    |> format_result_text(try_count)
    |> IO.puts()

    process_input(process_turn)
  end

  defp process_output({:bad_input, output, process_turn}) do
    IO.puts(output)
    process_input(process_turn)
  end

  # _type in :success, :gameover
  defp process_output({_type, guess, try_count, result, output}) do
    convert_guess_result(guess, result)
    |> format_result_text(try_count, output)
    |> IO.puts()
  end

  defp format_result_text(guess_result, try_count) do
    "#{guess_result} (#{try_count}/6)"
  end

  defp format_result_text(guess_result, try_count, msg) do
    """
    #{guess_result} (#{try_count}/6)
    #{msg}
    """
  end

  defp convert_guess_result(guess, result) do
    String.graphemes(guess)
    |> Enum.zip(result)
    |> Enum.map(&format_color/1)
    |> Enum.join("")
    |> Kernel.<>("\e[0m")
  end

  # yellow background
  defp format_color({g, :existed}) do
    "\e[43m\e[30m #{g} "
  end

  # green background
  defp format_color({g, :matched}) do
    "\e[42m\e[30m #{g} "
  end

  # grey background, white text
  defp format_color({g, _}) do
    "\e[100m\e[37m #{g} "
  end

  defp input_guess() do
    IO.gets("\nYour guess: ")
    |> String.trim()
    |> String.upcase()
  end

  defp display_instruction do
    IO.puts("""
    +-------------------------------------------------------------------+
    |     It's just Wordle game CLI version. I hope you enjoy it :)     |
    |             Word is 5 letters and you have 6 chances.             |
    +-------------------------------------------------------------------+
    """)
  end
end

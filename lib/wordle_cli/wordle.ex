defmodule WordleCli.Wordle do
  import WordleCli.Resources, only: [get_all_words: 0]
  import WordleCli.Answer, only: [select_answer: 1, is_guess_in_word_list?: 2, match: 2]

  @success_message %{
    1 => "Genius",
    2 => "Magnificent",
    3 => "Impressive",
    4 => "Splendid",
    5 => "Great",
    6 => "Phew"
  }

  def init_wordle_game() do
    answer = pick_answer()
    fn input -> process_turn(answer, input, 1) end
  end

  def process_turn(answer, guess, try_count) do
    case is_valid_guess?(guess) do
      {:ok} ->
        process_match(answer, guess, try_count)

      {:error, reason} ->
        {:bad_input, reason, fn input -> process_turn(answer, input, try_count) end}
    end
  end

  defp process_match(answer, guess, try_count) do
    match(answer, guess)
    |> process_match_result(answer, guess, try_count)
  end

  defp process_match_result({true, result}, _, guess, try_count) do
    {:success, guess, try_count, result, Map.get(@success_message, try_count)}
  end

  defp process_match_result({false, result}, answer, guess, try_count) when try_count == 6 do
    {:gameover, guess, try_count, result, "Sorry, answer was #{answer}."}
  end

  defp process_match_result({false, result}, answer, guess, try_count) do
    {:guess, guess, try_count, result,
     fn input -> process_turn(answer, input, try_count + 1) end}
  end

  defp is_valid_guess?(guess) do
    with {:ok} <- validate_guess_length(guess),
         {:ok} <- validate_guess_existence(guess) do
      {:ok}
    else
      err -> err
    end
  end

  defp validate_guess_length(guess) do
    case String.length(guess) == 5 do
      true -> {:ok}
      false -> {:error, "Word shoud be 5 letters."}
    end
  end

  defp validate_guess_existence(guess) do
    case get_all_words() |> is_guess_in_word_list?(guess) do
      true -> {:ok}
      false -> {:error, "#{guess} is not in word list."}
    end
  end

  defp pick_answer() do
    get_all_words() |> select_answer()
  end
end

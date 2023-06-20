defmodule WordleCli.Answer do
  def select_answer(word_list) when is_list(word_list) do
    word_list |> Enum.random()
  end

  def is_guess_in_word_list?(word_list, guess) do
    guess in word_list
  end

  def match(answer, guess) do
    result = match_guess(answer, guess)
    {success?(result), result}
  end

  defp success?(result),
    do: result == [:matched, :matched, :matched, :matched, :matched]

  defp match_guess(answer, guess) do
    answer_chars = String.graphemes(answer)
    guess_chars = String.graphemes(guess)

    inspect_matched_word(answer_chars, guess_chars)
    |> inspect_not_matched_word(answer_chars, guess_chars)
  end

  defp inspect_matched_word(answer_chars, guess_chars) do
    Enum.zip(answer_chars, guess_chars) |> Enum.map(&matched_or_not/1)
  end

  defp matched_or_not({a, g}) when a == g, do: :matched
  defp matched_or_not(_), do: :not_matched

  defp inspect_not_matched_word(matched_result, answer_chars, guess_chars) do
    get_not_matched_answer_chars(matched_result, answer_chars)
    |> inspect_existing_word(matched_result, guess_chars, [])
  end

  defp get_not_matched_answer_chars(matched_result, answer_chars) do
    Enum.zip(matched_result, answer_chars)
    |> Enum.filter(fn {r, _a} -> r == :not_matched end)
    |> Enum.map(fn {_r, a} -> a end)
  end

  defp inspect_existing_word(_rest_chars, [], [], inspect_result), do: inspect_result

  defp inspect_existing_word(rest_chars, [r | matched_result], [_g | guess], inspect_result)
       when r == :matched,
       do: inspect_existing_word(rest_chars, matched_result, guess, inspect_result ++ [r])

  defp inspect_existing_word(rest_chars, [_r | matched_result], [g | guess], inspect_result) do
    case g in rest_chars do
      true ->
        inspect_existing_word(
          List.delete(rest_chars, g),
          matched_result,
          guess,
          inspect_result ++ [:existed]
        )

      false ->
        inspect_existing_word(rest_chars, matched_result, guess, inspect_result ++ [:not_matched])
    end
  end
end

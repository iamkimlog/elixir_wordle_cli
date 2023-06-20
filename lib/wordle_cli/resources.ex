defmodule WordleCli.Resources do
  @word_resources Application.compile_env(:wordle_cli, :words_txt_path)

  @wordle_answers File.read!(@word_resources)
                  |> String.trim()
                  |> String.split("\n")

  def get_all_words() do
    @wordle_answers
  end
end

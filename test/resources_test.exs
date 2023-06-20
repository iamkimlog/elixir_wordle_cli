defmodule Wordle.ResourcesTest do
  use ExUnit.Case
  alias WordleCli.Resources

  test "words.txt 파일을 읽어올 수 있다." do
    assert length(Resources.get_all_words()) >= 3067
    assert List.last(Resources.get_all_words()) == "SEOUL"
  end

end

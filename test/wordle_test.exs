defmodule WordleTest do
  use ExUnit.Case
  alias WordleCli.Wordle

  test "get_process_func/0 - Wordle 게임을 초기화하고 process_turn 함수를 얻을 수 있다." do
    process_func = Wordle.init_wordle_game()
    assert is_function(process_func) == true
  end

  describe "process_turn/3" do
    test "5글자가 아닌 guess 에 대해 :bad_input, 해당 에러 메세지를 반환한다." do
      actual = Wordle.process_turn("HELLO", "ABC", 1)
      assert {:bad_input, "Word shoud be 5 letters.", _} = actual

      actual = Wordle.process_turn("HELLO", "ABCDEF", 1)
      assert {:bad_input, "Word shoud be 5 letters.", _} = actual
    end

    test "정답 리스트에 없는 guess 인 경우 :bad_input, 해당 에러 메세지를 반환한다." do
      actual = Wordle.process_turn("HELLO", "NOTIN", 1)
      assert {:bad_input, "NOTIN is not in answers list.", _} = actual
    end

    test "guess 가 틀렸을 경우 :guess 를 반환한다." do
      actual = Wordle.process_turn("HELLO", "PIANO", 1)
      assert {:guess, "PIANO", 1, _, _} = actual
    end

    test "guess 를 6번 실패한 경우 :gameover 와 정답 메세지를 반환한다." do
      actual = Wordle.process_turn("HELLO", "PIANO", 6)
      assert {:gameover, "PIANO", 6, _, "Sorry, answer was HELLO."} = actual
    end

    test "정답을 맞춘 경우 :success 와 시도 횟수에 맞는 정답 메세지를 반환한다." do
      actual = Wordle.process_turn("HELLO", "HELLO", 1)
      assert {:success, "HELLO", 1, _, "Genius"} = actual

      actual = Wordle.process_turn("HELLO", "HELLO", 2)
      assert {:success, "HELLO", 2, _, "Magnificent"} = actual

      actual = Wordle.process_turn("HELLO", "HELLO", 3)
      assert {:success, "HELLO", 3, _, "Impressive"} = actual

      actual = Wordle.process_turn("HELLO", "HELLO", 4)
      assert {:success, "HELLO", 4, _, "Splendid"} = actual

      actual = Wordle.process_turn("HELLO", "HELLO", 5)
      assert {:success, "HELLO", 5, _, "Great"} = actual

      actual = Wordle.process_turn("HELLO", "HELLO", 6)
      assert {:success, "HELLO", 6, _, "Phew"} = actual
    end
  end
end

defmodule AnswerTest do
  alias WordleCli.Answer
  use ExUnit.Case
  
  describe "match/2 의 다양한 입력에 대해 테스트한다." do
    test "모든 문자가 일치하는 경우" do
      assert Answer.match("APPLE", "APPLE") == { true, [:matched, :matched, :matched, :matched, :matched] }
    end

    test "일부 문자가 정확히 일치하고, 일부 문자가 위치는 다르지만 포함되는 경우" do 
      assert Answer.match("APPLE", "ELPPA") == { false, [:existed, :existed, :matched, :existed, :existed] }
      assert Answer.match("PIANO", "OIAPN") == { false, [:existed, :matched, :matched, :existed, :existed] }
    end

    test "모든 문자가 위치는 다르지만 포함되는 경우" do 
      assert Answer.match("APPLE", "PALEP") == { false, [:existed, :existed, :existed, :existed, :existed] }
      assert Answer.match("PIANO", "ONIPA") == { false, [:existed, :existed, :existed, :existed, :existed] }
    end

    test "일부 문자가 정확히 일치하고, 일부 문자는 위치는 다르지만 포함되고, 일부 문자는 존재하지 않는 경우" do
      assert Answer.match("APPLE", "ELPPX") == { false, [:existed, :existed, :matched, :existed, :not_matched] }
      assert Answer.match("PIANO", "OIAXN") == { false, [:existed, :matched, :matched, :not_matched, :existed] }
    end

    test "일부 문자가 정확히 일치하고, 일부 문자는 위치는 다르지만 포함되고, 일부 문자는 정답에 나온 문자 수보다 더 많이 나온 경우" do
      assert Answer.match("APPLE", "POPUP") == { false, [:existed, :not_matched, :matched, :not_matched, :not_matched] }
      assert Answer.match("APPLE", "PPPPP") == { false, [:not_matched, :matched, :matched, :not_matched, :not_matched] }
    end

    test "일치하는 문자가 없는 경우" do
      assert Answer.match("APPLE", "XYCZV") == { false, [:not_matched, :not_matched, :not_matched, :not_matched, :not_matched] }
    end
  end

end

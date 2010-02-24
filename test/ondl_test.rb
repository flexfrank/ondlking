# encoding : utf-8
require "minitest/unit"
require_relative "../ondl"

MiniTest::Unit.autorun

class TestOndl < MiniTest::Unit::TestCase
  def setup
    @ondl=Ondl.new
  end
  #def test_translate
  #  assert_equal "ｵﾝﾄﾞｩﾙﾙﾗｷﾞｯﾀﾝﾃﾞｨｽｶ",@ondl.translate("本当に裏切ったんですか")
  #end

  def test_word
    assert_equal "ｼﾞｬ",@ondl.translate_word("りゃ")
    assert_equal "ﾍﾞ",@ondl.translate_word("め")
    assert_nil @ondl.translate_word("めだか")
  end
  def test_with_rest
    assert_equal ["ﾍﾞ","だか"],@ondl.translate_with_rest("めだか")
    assert_equal ["ｵﾝﾄﾞｩﾙ",""],@ondl.translate_with_rest("ほんとうに")
    assert_equal ["!","あ"],@ondl.translate_with_rest("!あ")
    assert_equal ["x","あ"],@ondl.translate_with_rest("xあ")
  end
  def test_translate_kana
    assert_equal "ｵﾝﾄﾞｩﾙﾙﾗｷﾞｯﾀﾝﾃﾞｨｽｶ",@ondl.translate_kana("ほんとうにうらぎったんですか")
  end
end

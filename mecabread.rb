# encoding : utf-8

require "MeCab"
require "nkf"
class MeCabReading
  def initialize
    @mecab=MeCab::Tagger.new("-Oyomi")
  end
  def reading(text)
    NKF.nkf("-wWx -h1", @mecab.parse(text))
  end
end

if($0==__FILE__)
  puts MeCabReading.new.reading("本当に裏切ったasfasfんですか")
end


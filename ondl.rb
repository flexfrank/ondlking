#encoding : utf-8

require "yaml"
require_relative "apis"

class Ondl
  def initialize(parser=nil)
    dicpath=File.join(File.expand_path(File.dirname(__FILE__)),"dic.yml")
    @dic=YAML.load_file(dicpath)
    @maxlength=@dic.keys.max_by{|w|w.size}.size
    @parser=parser
  end

  def translate(text)
    translate_kana @parser.reading(text)
  end

  def translate_kana(text)
    result=""
    str=text
    while str && !str.empty?
      word,rest=translate_with_rest(str)
      result << word
      str=rest
    end
    result
  end

  def translate_with_rest(text)
    
    @maxlength.downto(1) do|size|
      translated = translate_word(text[0,size])
      if(translated)
        return [translated,text[size,text.size]||""]
      end
    end
    return [text[0],text[1,text.size]||""]
  end

  def translate_word(word)
    @dic.has_key?(word) ? @dic[word] : nil
  end
end

if __FILE__ == $0
  ondl=Ondl.new
end

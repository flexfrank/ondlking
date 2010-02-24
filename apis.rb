# encoding: utf-8
require "open-uri"
require "net/http"
require "rubygems"
require "nokogiri"
require "nkf"

class AbstractAPI
  module NokogiriHelper
    def xpath(node,*paths)
      node.xpath(*(paths+[node.document.namespaces]))
    end
  end
  def initialize(appid,opts={})
    @appid=appid
    @opts=opts
    @proxy=opts[:proxy]
  end

  def get(uri)
    #$stderr.puts(uri)
    str=uri.read(:proxy=>@proxy && @proxy.to_s)
  end
  
  def post(uri)
    body=nil
    http_class= @proxy ?  Net::HTTP.Proxy(@proxy.host,@proxy.port) : Net::HTTP
    http_class.start(uri.host,uri.port) do|h|
      body=h.post(uri.path,uri.query).body
    end
    body
  end

  def e(str)
    URI.escape(str)
  end
end

class YahooAPI < AbstractAPI
  Word=Struct.new(:surface,:reading,:pos,:baseform,:type)
  

  def words_from_node(doc,ns)
    word_nodes=doc.xpath("/ns:ResultSet/ns:ma_result/ns:word_list/ns:word",ns)
    word_nodes.map{|x|word_from_node(x,ns)}
  end
  def word_from_node(word_node,ns)
    surface=word_node.xpath("ns:surface",ns).text
    reading=word_node.xpath("ns:reading",ns).text
    pos=word_node.xpath("ns:pos",ns).text
    baseform=word_node.xpath("ns:baseform",ns).text
    feature=word_node.xpath("ns:feature",ns).text.split(/,/)
    Word.new(surface,reading,pos,baseform,feature[1])
  end

  def readings(sentence)
    morph(sentence).map{|w|w.reading}
  end
  def reading(sentence)
    NKF.nkf("-Ww -h1",readings(sentence).join(""))
  end

  def morph(sentence)
    #sentence=sentence.gsub(/\s+/," ")
    uri=URI.parse("http://jlp.yahooapis.jp/MAService/V1/parse?appid=#{@appid}&sentence=#{e sentence}&response=surface,pos,feature,reading,baseform")
    xml=post(uri)
    words_from_node(Nokogiri.XML(xml),{"ns"=>"urn:yahoo:jp:jlp"})
  end
end


if $0==__FILE__
  yapi=YahooAPI.new("agyjofaxg652ECTBFueopGKzabwis0iACOhcrl8Am59fpTERMfMzkX2zi90qmdo3hHtBOwJb")

  p yapi.reading("月は無慈悲な夜の女王")
  p yapi.reading("アンドロイドは電気羊の夢を見るか?")
  p yapi.reading("本当に裏切ったんですか")
  p yapi.reading("カタカナダトダメ")
end

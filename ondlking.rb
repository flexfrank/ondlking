# encoding: utf-8
require "rubygems"
require "rack"
require_relative "ondl"
require "uri"
require "json"
#require_relative "mecabread"
class OndlKingApp
  def initialize(params={})
    @ondl=Ondl.new(YahooAPI.new(params[:yahookey]))
    @baseurl="http://flexfrank.net/cgi/ondlking/index.html#"
    @bitlykey=params[:bitlykey] 
    @bitlyid=params[:bitlyid] 
  end

  def shortenURL(query)
    url=URI.escape(@baseurl+query)
    requrl="http://api.bit.ly/shorten?version=2.0.1&longUrl=#{url}&apiKey=#{@bitlykey}&login=#{@bitlyid}"
    result=JSON.load(URI.parse(requrl).open.read)
    result.inspect
    if result["errorCode"]==0
      result["results"].values[0]["shortCNAMEUrl"]
    else
      ""
    end
  end
 
  def message(query)
    @ondl.translate(query)+" "+shortenURL(query)
  end
  
  def call(env)
    query=Rack::Utils.unescape(env["QUERY_STRING"])
    query.force_encoding("UTF-8")
    case env["PATH_INFO"]
    when "/message"
      [200, {"Content-Type"=>"text/plain; charset=UTF-8 "},[message(query)]];
    else
      [200, {"Content-Type"=>"text/plain; charset=UTF-8 "},[@ondl.translate(query)]]
    end
  end
end

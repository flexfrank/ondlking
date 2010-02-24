#!/usr/local/bin/ruby19
# encoding: utf-8
require_relative "ondlking"
Rack::Handler::CGI.run(
  OndlKingApp.new(
    bitlykey: "your bit.ly api key", 
    bitlyid: "your bit.ly id", 
    yahookey: "your Yahoo! Japan API Key"))

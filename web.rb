# encoding: utf-8

load "main.rb"
require 'sinatra'
require 'haml'

get "/" do
  expires 300, :public, :must_revalidate
  etag "plugins"

  @plugins = Plugin.all
  haml :index
end

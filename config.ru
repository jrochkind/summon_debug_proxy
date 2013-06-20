require 'rubygems'
require 'bundler'

Bundler.require

require './summon_debug_proxy'
run Sinatra::Application


require 'rubygems'
require 'sinatra'

configure { set :server, :puma }

require File.expand_path '../lib/rest-ldap/api.rb', __FILE__
run Sinatra::Application

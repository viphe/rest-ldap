require 'rubygems'
require 'sinatra'

configure { set :server, :puma }

Dir["./app/models/*.rb"].each { |file| require file }
Dir["./app/controllers/*.rb"].each { |file| require file }

run Sinatra::Application

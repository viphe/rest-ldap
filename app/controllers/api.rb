require 'rubygems'
require 'sinatra'
require 'json'

get '/:owner/:name/users' do |owner, name|
  request.body.rewind
  payload = JSON.parse(request.body.read, symbolize_names: true)
  configuration = payload[:configuration]

  tenant = Tenants.instance.get_or_create(owner, name, configuration)
  halt 404 if tenant.nil?

  limit = request[:limit] || 10
end

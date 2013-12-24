require 'rubygems'
require 'sinatra'

get '/' do
  %Q{
    <html>
      <body>
      Hello from the 
      <strong>wonderful</strong> 
      world of JRuby!
      </body>
      </html>
  }
end

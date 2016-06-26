require "sinatra"
require "sinatra/reloader" if development?
require "sinatra/content_for"
require "tilt/erubis"

configure do

end

helpers do

end

before do

end

get "/" do
  "Getting Started."
end

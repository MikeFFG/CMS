require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/content_for'
require 'tilt/erubis'
require 'pry'

root = File.expand_path('..', __FILE__)

configure do
  enable :sessions
  set :session_secret, 'secret'
end

helpers do

end

before do

end

get '/' do
  @files = Dir.glob(root + '/data/*').map do |path|
    File.basename(path)
  end
  erb :index
end

get '/:filename' do
  file_path = root + '/data/' + params[:filename]
  headers["Content-Type"] = "text/plain"
  if File.exist?(file_path)
    File.read(file_path)
  else
    session[:message] = "#{params[:filename]} does not exist."
    redirect '/'
  end
end

require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/content_for'
require 'tilt/erubis'
require "redcarpet"
require 'pry'

root = File.expand_path('..', __FILE__)

configure do
  enable :sessions
  set :session_secret, 'secret'
end

helpers do
  def render_markdown(text)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    markdown.render(text)
  end

  def load_file_content(path)
    content = File.read(path)
    case File.extname(path)
    when '.txt'
      headers["Content-Type"] = "text/plain"
      content
    when '.md'
      render_markdown(content)
    end
  end
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

  if File.exist?(file_path)
    load_file_content(file_path)
  else
    session[:message] = "#{params[:filename]} does not exist."
    redirect '/'
  end
end

post '/:filename' do
  file_path = root + "/data/" + params[:filename]

  File.write(file_path, params[:content])

  session[:message] = "#{params[:filename]} has been updated."
  redirect "/"
end

get '/:filename/edit' do
  file_path = root + '/data/' + params[:filename]

  @filename = params[:filename]
  @content = File.read(file_path)

  erb :edit
end

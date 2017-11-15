# set :environment, :production
require 'sinatra'
require './rsg'

set :views, "views"

get '/' do
  files = Dir['grammars/*']
  files.map { |f| f.split('/') }
  files.collect! { |splits| File.basename(splits, ".g") }
  @arr = files
  erb :rsg_page
end

post '/' do
  RSGme = params[:RSGme] || "Broke"
  files = Dir['grammars/*']
  files.map { |f| f.split('/') }
  files.collect! { |splits| File.basename(splits, ".g") }
  if files.include? RSGme
    if RSGme != "Kant"
      sentence = rsg(RSGme)
      @arr = files
      @choice = sentence
      erb :rsg_page
    else
      @haxor = "That option does not work, try picking another from the list!"
      @arr = files
      erb :rsg_page
    end
  else
    @haxor = "That option does not exist, try picking one from the list!"
    @arr = files
    erb :rsg_page
  end
end

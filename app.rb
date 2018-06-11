require "sinatra/base"
require_relative "command"

class App < Sinatra::Base
  set :erb, :escape_html => true

  def title
    "Passenger App Processes"
  end

  def current_user
    ENV["USER"]
  end

  get "/" do
    @command = Command.new
    @processes, @error = @command.exec

    erb :index
  end
end

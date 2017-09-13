require 'sinatra'
require 'sinatra/reloader' if development?
require 'open3'
require 'erubi'

set :erb, :escape_html => true

# A Struct is used to map each stdout column to an attribute.
# There are 9 columns for each line of output from the quota command.
Volume = Struct.new(:name, :blocks, :blocks_quota, :blocks_limit, :blocks_grace, :files, :files_quota, :files_limit, :files_grace)

helpers do
  # This command will parse a string output from the `quota -spw` command and map it to
  #  an array of Volume objects.
  #
  # Example output of the quota command: quota -spw
  # Disk quotas for user efranz (uid 10851):
  #      Filesystem  blocks   quota   limit   grace   files   quota   limit grace
  # 10.11.200.31:/PZS0562/  99594M    500G    500G       0    929k   1000k   1000k       0
  def parse_quota(quota_string)
    lines = quota_string.split("\n")
    lines.drop(2).map { |line| Volume.new(*(line.split)) }
  end
end

# Define a route at the root '/' of the app.
get '/' do
  # Define your variables that will be sent to the view.
  @title = "Quota"
  @command = "quota -spw"

  # Run the command and capture the stdout, stderr, and exit code as separate variables.
  stdout_str, stderr_str, status = Open3.capture3(@command)

  # Parse the stdout of the command and set the resulting object array to a variable.
  @volumes = parse_quota(stdout_str)

  # If there was an error performing the command, set it to an error variable.
  @error = stderr_str unless status.success?

  # Variables will be available in views/index.erb
  erb :index
end

run Sinatra::Application

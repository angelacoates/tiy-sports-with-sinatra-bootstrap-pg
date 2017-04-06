require 'sinatra'
require 'pg'
require 'sinatra/reloader' if development?
require 'active_record'

ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Base.establish_connection(
adapter: "postgresql",
database: "tiy-sports"
)

class Team < ActiveRecord::Base
  self.primary_key = "id"
end

after do
  ActiveRecord::Base.connection.close
end

get '/' do
  @teams = Team.all

  erb :home
end

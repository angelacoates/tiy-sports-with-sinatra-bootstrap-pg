require 'sinatra'
require 'pg'
require 'sinatra/reloader' if development?
require 'active_record' if development?

require 'better_errors'
require 'binding_of_caller'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = __dir__
end

ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Base.establish_connection(
adapter: "postgresql",
database: "tiy-sports"
)
after do
  ActiveRecord::Base.connection.close
end

class Team < ActiveRecord::Base
  self.primary_key = "id"
  has_many :memberships
  has_many :players, through: :memberships
  has_many :games
end

class Player < ActiveRecord::Base
  has_many :memberships
  belongs_to :team
  self.primary_key = "id"
end

class Membership < ActiveRecord::Base
  belongs_to :player_id
  belongs_to :player
end

class Game < ActiveRecord::Base
  belongs_to :away_team_id, class_name: 'Team'
  belongs_to :home_team_id, class_name: 'Team'
end

get '/' do
  @teams = Team.all
  erb :home
end

get '/games' do
  @games = Game.all

  erb :game
end

require 'sinatra'
require 'pg'
require 'sinatra/reloader' if development?
require 'active_record' if development?

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
  has_many :player
  has_many :teams, through: :players
end

class Player < ActiveRecord::Base
  has_many :memberships
  has_many :players, through: :memberships
end

class Membership < ActiveRecord::Base
  belongs_to :player_id
  belongs_to :team_id
end

get '/' do
  @teams = Team.all

  erb :home
end

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

get '/' do
  @teams = Team.all
  erb :home

end

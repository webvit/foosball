class Game
  include Mongoid::Document
  include Mongoid::Timestamps

  field :left_team_score, type: Integer
  field :right_team_score, type: Integer

  embedded_in :match

end
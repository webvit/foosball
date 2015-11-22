class Match
  include Mongoid::Document
  include Mongoid::Timestamps

  embeds_many :players
  embeds_many :games

  accepts_nested_attributes_for :players, limit: 4
  accepts_nested_attributes_for :games, limit: 3

  Chewy.strategy(:urgent)

  update_index 'matches#match', :self
end

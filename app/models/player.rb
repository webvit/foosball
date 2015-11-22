class Player
  include Mongoid::Document
  include Mongoid::Timestamps
  extend Enumerize

  field :team

  enumerize :team, in: [:left, :right]

  belongs_to :user, inverse_of: :players
  embedded_in :match
end

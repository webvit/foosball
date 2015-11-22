class MatchesIndex < Chewy::Index
  define_type Match do
    field :players, type: 'object' do
      field :player, value: ->{ user_id.to_s }
      field :team
    end
    field :games, type: 'object' do
      field :game, value: ->{ id.to_s }
      field :left_team_score, type: 'integer'
      field :right_team_score, type: 'integer'
    end
  end
end

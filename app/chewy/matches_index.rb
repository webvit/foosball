class MatchesIndex < Chewy::Index
  define_type Match do
    field :players, type: 'nested' do
      field :player, value: ->{ user_id.to_s }
      field :team
      field :match_score, type: 'integer', value: ->(player, match) { match.games.sum("#{player.team}_team_score") }
      field :avg_score, type: 'float', value: ->(player, match) { match.games.avg("#{player.team}_team_score") }
      field :winned_games, type: 'integer',
        value: ->(player, match) do
          match.games.map{ |game| game["#{player.team}_team_score"] == 10 ? 1 : 0 }.inject(:+)
        end
    end
    field :game_count, type: 'integer', value: -> { games.count }
    field :games, type: 'nested' do
      field :game, value: ->{ id.to_s }
      field :left_team_score, type: 'integer'
      field :right_team_score, type: 'integer'
    end
  end
end

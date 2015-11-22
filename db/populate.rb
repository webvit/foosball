User.delete_all
Match.delete_all

user1 = User.create(name: 'Jonn')
user2 = User.create(name: 'Linda')
user3 = User.create(name: 'Sasha')
user4 = User.create(name: 'Maria')

Match.create(
  players: [
    Player.new(
      user_id: user1.id,
      team: :left
    ),
    Player.new(
      user_id: user4.id,
      team: :left
    ),
    Player.new(
      user_id: user2.id,
      team: :right
    )
  ],
  games: [
    Game.new(
      left_team_score: 10,
      right_team_score: 7
    ),
    Game.new(
      left_team_score: 2,
      right_team_score: 10
    ),
    Game.new(
      left_team_score: 5,
      right_team_score: 10
    )
  ]
)

Match.create(
  players: [
    Player.new(
      user_id: user3.id,
      team: :left
    ),
    Player.new(
      user_id: user1.id,
      team: :right
    )
  ],
  games: [
    Game.new(
      left_team_score: 1,
      right_team_score: 10
    ),
    Game.new(
      left_team_score: 5,
      right_team_score: 10
    )
  ]
)


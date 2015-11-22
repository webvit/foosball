class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    user = @user.id.to_s
    result = MatchesIndex.filter{match_all}
      .search_type('count')
      .aggs(
        "rating" => {
           "nested" => {
              "path" => "players"
           },
           "aggs" => {
              "place" => {
                 "terms" => {
                    "field" => "players.player",
                    "order" => {
                       "avg_score_sort" => "desc"
                    }
                 },
                 "aggs" => {
                    "avg_score_sort" => {
                       "avg" => {
                          "field" => "players.avg_score"
                       }
                    }
                 }
              }
           }
        },
        "statistics" => {
           "filter" => {
              "nested" => {
                 "path" => "players",
                 "query" => {
                    "match" => {
                       "players.player" => user
                    }
                 }
              }
           },
           "aggs" => {
              "match_count" => {
                 "value_count" => {
                    "field" => "game_count"
                 }
              },
              "game_count" => {
                 "sum" => {
                    "field" => "game_count"
                 }
              },
              "players" => {
                 "nested" => {
                    "path" => "players"
                 },
                 "aggs" => {
                    "player" => {
                       "filter" => {
                          "query" => {
                             "match" => {
                                "players.player" => user
                             }
                          }
                       },
                       "aggs" => {
                          "total_score" => {
                             "sum" => {
                                "field" => "players.match_score"
                             }
                          },
                          "avg_score" => {
                             "avg" => {
                                "field" => "players.avg_score"
                             }
                          },
                          "winned_games" => {
                             "sum" => {
                                "field" => "players.winned_games"
                             }
                          },
                          "winned_matches" => {
                             "filter" => {
                                "query" => {
                                   "range" => {
                                      "players.match_score" => {
                                         "gte" => 20
                                      }
                                   }
                                }
                             }
                          }
                       }
                    }
                 }
              }
           }
        }
      )
    stats = result.aggs['statistics']
    player = stats['players']['player']

    @statistics = {
      match_count: stats['match_count']['value'],
      game_count: stats['game_count']['value'],
      total_score: player['total_score']['value'],
      avg_score: player['avg_score']['value'],
      winned_games: player['winned_games']['value'],
      winned_matches: player['winned_matches']['doc_count']
      # all: result.aggs
    }
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params[:user]
    end
end

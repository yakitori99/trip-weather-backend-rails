class FavoritesController < ApplicationController
  before_action :set_favorite, only: [:show, :update, :destroy]


  # favoritesテーブルから重複しないニックネーム一覧を取得し、ニックネームの昇順で返す
  def get_nicknames
    @favorites = Favorite.select(:nickname).distinct.order('nickname ASC')
    # jbuilderを用いてjsonの整形・レンダリングを行う
  end

  # GET /favorites
  def index
    @favorites = Favorite.all

    render json: @favorites
  end

  # GET /favorites/1
  def show
    render json: @favorite
  end

  # POST /favorites
  def create
    @favorite = Favorite.new(favorite_params)

    if @favorite.save
      render json: @favorite, status: :created, location: @favorite
    else
      render json: @favorite.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /favorites/1
  def update
    if @favorite.update(favorite_params)
      render json: @favorite
    else
      render json: @favorite.errors, status: :unprocessable_entity
    end
  end

  # DELETE /favorites/1
  def destroy
    @favorite.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_favorite
      @favorite = Favorite.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def favorite_params
      params.require(:favorite).permit(:nickname, :from_pref_code, :from_city_code, :to_pref_code, :to_city_code)
    end
end

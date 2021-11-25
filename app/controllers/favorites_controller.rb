class FavoritesController < ApplicationController  
  
  # favoritesテーブルから重複しないニックネーム一覧を取得し、ニックネームの昇順で返す
  def get_nicknames
    @favorites = Favorite.select(:nickname).distinct.order('nickname ASC')
    # jbuilderを用いてjsonの整形・レンダリングを行う
  end


  # favoritesテーブルからニックネームをキーに検索し、更新日時降順で全件を取得して返す
  def get_favorites_by_nickname
    nickname = params[:nickname]
    # ニックネームなしを表す文字列の場合、空文字を代入
    if nickname == NO_NICKNAME
      nickname = ""
    end

    # DB検索
    results = Favorite.select_favorites_by_nickname(nickname)
    # UpdatedAtの日付文字列形式を変換
    results.each_index do |i|
      results[i]["UpdatedAt"] = results[i]["UpdatedAt"].in_time_zone.strftime("%Y/%m/%d %H:%M:%S")
    end

    render json: results
  end


  # 受け取ったJSON(nickname, from_city_code, to_city_code)を用いてfavoritesテーブルに対しINSする
  # (同一レコードが存在する場合は更新日時のみUPD)
  def post_favorites
    # params取得
    nickname = params[:nickname]
    from_city_code = params[:from_city_code]
    to_city_code   = params[:to_city_code]
    
    # nicknameの空白文字は削除(半角/全角とも)
    nickname = nickname.delete(" 　")
    
    # DBにINS or UPD
    result_code = Favorite.ins_upd_favorites(nickname, from_city_code, to_city_code)
    
    if result_code == FAVORITES_DONE_CODE_ERR
      render status: 400, json: { status:400, message:"Bad Request"} and return
    else
      # statusはCreated, ResultCodeはINS/UPDの判別のために渡す
      render status: 201, json: {ResultCode:result_code} and return
    end
  end

  private
  # Only allow a list of trusted parameters through.
  def favorite_params
    params.require(:favorite).permit(:nickname, :from_pref_code, :from_city_code, :to_pref_code, :to_city_code)
  end
end

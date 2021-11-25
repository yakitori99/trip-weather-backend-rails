class FavoritesController < ApplicationController  
  
  GET_FAVORITES_BY_NICKNAME_SQL = <<-"EOS"
  select
  f.nickname as Nickname, 
  f.from_pref_code as FromPrefCode, 
  f.from_city_code as FromCityCode, 
  f.to_pref_code   as ToPrefCode,
  f.to_city_code   as ToCityCode,
  p1.pref_name as FromPrefName, 
  c1.city_name as FromCityName, 
  p2.pref_name as ToPrefName,
  c2.city_name as ToCityName,
  f.updated_at as UpdatedAt
  from favorites f
  LEFT OUTER JOIN prefs p1 on f.from_pref_code = p1.pref_code
  LEFT OUTER JOIN prefs p2 on f.to_pref_code = p2.pref_code 
  LEFT OUTER JOIN cities c1 on f.from_city_code = c1.city_code
  LEFT OUTER JOIN cities c2 on f.to_city_code = c2.city_code 
  where f.nickname = (:nickname) 
  order by f.updated_at desc
  EOS

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
    
    # プレースホルダに変数を渡しsqlを生成
    sql = ActiveRecord::Base.sanitize_sql_array([GET_FAVORITES_BY_NICKNAME_SQL, nickname: nickname])
    # sqlを実行し、取得結果をarray of hashに変換して代入
    results = ActiveRecord::Base.connection.select_all(sql).to_a
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
    nickname = nickname.gsub(" ", "")
    nickname = nickname.gsub("　", "")
    
    # DBにINS or UPD
    result_code = Favorite.ins_upd_favorites(nickname, from_city_code, to_city_code)
    
    if result_code == FAVORITES_DONE_CODE_ERR
      render status: 400, json: { status:400, message:"Bad Request"} and return
    else
      # statusはCreated, ResultCodeはINS/UPDの判別のために渡す
      render status: 201, json: {ResultCode:result_code} and return
    end
  end

end

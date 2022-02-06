class Favorite < ApplicationRecord
  
  SELECT_FAVORITES_BY_NICKNAME_SQL = <<-"EOS"
  select
  f.nickname as "Nickname", 
  f.from_pref_code as "FromPrefCode", 
  f.from_city_code as "FromCityCode", 
  f.to_pref_code   as "ToPrefCode",
  f.to_city_code   as "ToCityCode",
  p1.pref_name as "FromPrefName", 
  c1.city_name as "FromCityName", 
  p2.pref_name as "ToPrefName",
  c2.city_name as "ToCityName",
  f.updated_at as "UpdatedAt"
  from favorites f
  LEFT OUTER JOIN prefs p1 on f.from_pref_code = p1.pref_code
  LEFT OUTER JOIN prefs p2 on f.to_pref_code = p2.pref_code 
  LEFT OUTER JOIN cities c1 on f.from_city_code = c1.city_code
  LEFT OUTER JOIN cities c2 on f.to_city_code = c2.city_code 
  where f.nickname = (:nickname) 
  order by f.updated_at desc
  EOS

  def self.select_favorites_by_nickname(nickname)
    # プレースホルダに変数を渡しsqlを生成
    sql = ActiveRecord::Base.sanitize_sql_array([SELECT_FAVORITES_BY_NICKNAME_SQL, nickname: nickname])
    # sqlを実行し、取得結果をarray of hashに変換して代入
    results = ActiveRecord::Base.connection.select_all(sql).to_a
    return results
  end


  # 受け取ったnickname, from_city_code, to_city_codeを用いて
  # favoritesテーブルに対しINSするクラスメソッド
  # (同一レコードが存在する場合は更新日時のみUPD)
  def self.ins_upd_favorites(nickname, from_city_code, to_city_code)
    # from_city_code , to_city_codeの片方でもcitiesテーブルに存在しない場合はエラーとする
    from_exist = City.where("city_code = ?", from_city_code).exists?
    to_exist = City.where("city_code = ?", to_city_code).exists?
    if from_exist == false or to_exist == false
      result_code = Constants::FAVORITES_DONE_CODE_ERR
      return result_code
    end

    # timeはDBへの登録時にUTCに変換されてしまうが、DBの値を日本時間で登録したいため以下を行う
    # 登録/更新時：now(JST) + 9時間 -> UTCで見たときにnow(JST)と同じ日時が登録される
    # 参照時：DBの値がJSTなので、そのまま利用する
    time_now = Time.zone.now + 9.hours

    # SELECTして同一レコードが存在するかチェック
    favorite_exist = Favorite.where("nickname = ? AND from_city_code = ? AND to_city_code = ?",
                                    nickname, from_city_code, to_city_code).exists?
    
    if favorite_exist
      # 同一レコードがあればupdate_atのみUPDATE # 原則更新対象は1レコードのみだが、複数も許容する
      Favorite.where("nickname = ? AND from_city_code = ? AND to_city_code = ?",
                     nickname, from_city_code, to_city_code
                    ).update_all(updated_at: time_now)
      result_code = Constants::FAVORITES_DONE_CODE_UPD
    else
      # 同一レコードがなければINSERT
      Favorite.create(nickname: nickname,
                      from_pref_code: from_city_code[0..1],
                      from_city_code: from_city_code,
                      to_pref_code: to_city_code[0..1],
                      to_city_code: to_city_code,
                      created_at: time_now,
                      updated_at: time_now)

      result_code = Constants::FAVORITES_DONE_CODE_INS
    end

    return result_code
  end
end

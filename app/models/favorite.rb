class Favorite < ApplicationRecord
  
  # 受け取ったnickname, from_city_code, to_city_codeを用いて
  # favoritesテーブルに対しINSするクラスメソッド
  # (同一レコードが存在する場合は更新日時のみUPD)
  def self.ins_upd_favorites(nickname, from_city_code, to_city_code)
    # from_city_code , to_city_codeの片方でもcitiesテーブルに存在しない場合はエラーとする
    from_exist = City.where("city_code = ?", from_city_code).exists?
    to_exist = City.where("city_code = ?", to_city_code).exists?
    if from_exist == false or to_exist == false
      result_code = FAVORITES_DONE_CODE_ERR
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
      result_code = FAVORITES_DONE_CODE_UPD
    else
      # 同一レコードがなければINSERT
      Favorite.create(nickname: nickname,
                      from_pref_code: from_city_code[0..1],
                      from_city_code: from_city_code,
                      to_pref_code: to_city_code[0..1],
                      to_city_code: to_city_code,
                      created_at: time_now,
                      updated_at: time_now)

      result_code = FAVORITES_DONE_CODE_INS
    end

    return result_code
  end
end

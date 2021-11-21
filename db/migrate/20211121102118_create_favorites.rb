class CreateFavorites < ActiveRecord::Migration[6.1]
  def change
    create_table :favorites do |t|
      t.text :nickname
      t.text :from_pref_code
      t.text :from_city_code
      t.text :to_pref_code
      t.text :to_city_code

      t.timestamps
    end
  end
end

class CreateCities < ActiveRecord::Migration[6.1]
  def change
    create_table :cities do |t|
      t.text :city_code
      t.text :city_name
      t.text :pref_code
      t.text :city_kana
      t.text :city_romaji
      t.text :city_romaji_location
      t.float :city_lon
      t.float :city_lat

      t.timestamps
    end
  end
end

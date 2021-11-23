class CitiesController < ApplicationController
  # GET
  def get_city_all
    @cities = City.all.order('city_code ASC')
    # jbuilderを用いてjsonの整形・レンダリングを行うため、以下のrenderは使わない
    # render json: @cities
  end


  private
    # Only allow a list of trusted parameters through.
    def city_params
      params.require(:city).permit(:city_code, :city_name, :pref_code, :city_kana, :city_romaji, :city_romaji_location, :city_lon, :city_lat)
    end
end

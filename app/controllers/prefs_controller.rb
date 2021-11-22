class PrefsController < ApplicationController
  # GET
  def get_pref_all
    @prefs = Pref.all.order('pref_code ASC')
    # jbuilderを用いてjsonの整形・レンダリングを行うため、以下のrenderは使わない
    # render json: @prefs
  end


  private
    # Only allow a list of trusted parameters through.
    def pref_params
      params.require(:pref).permit(:pref_code, :pref_name)
    end
end

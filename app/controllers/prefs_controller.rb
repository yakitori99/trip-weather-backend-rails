class PrefsController < ApplicationController
  # GET
  def get_pref_all
    @prefs = Pref.all.order('pref_code ASC'
                           ).as_json(only:['pref_code', 'pref_name'])

    render json: @prefs
  end


  private
    # Only allow a list of trusted parameters through.
    def pref_params
      params.require(:pref).permit(:pref_code, :pref_name)
    end
end

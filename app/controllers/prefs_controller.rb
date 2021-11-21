class PrefsController < ApplicationController
  before_action :set_pref, only: [:show, :update, :destroy]

  # GET /prefs
  def index
    @prefs = Pref.all

    render json: @prefs
  end

  # GET /prefs/1
  def show
    render json: @pref
  end

  # POST /prefs
  def create
    @pref = Pref.new(pref_params)

    if @pref.save
      render json: @pref, status: :created, location: @pref
    else
      render json: @pref.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /prefs/1
  def update
    if @pref.update(pref_params)
      render json: @pref
    else
      render json: @pref.errors, status: :unprocessable_entity
    end
  end

  # DELETE /prefs/1
  def destroy
    @pref.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pref
      @pref = Pref.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pref_params
      params.require(:pref).permit(:pref_code, :pref_name)
    end
end

class BusinessHoursController < ApplicationController
  before_action :set_business
  before_action :set_business_hour, only: [:show, :edit, :update, :destroy]

  # GET /business_hours
  # GET /business_hours.json
  def index
    @business_hours = @business.business_hours.all.order(:day)
  end

  # GET /business_hours/1
  # GET /business_hours/1.json
  def show
  end

  # POST /business_hours
  # POST /business_hours.json
  def create
    @business_hour = BusinessHour.new(business_hour_params)
    @business_hour.business_id = params[:business_id]

    respond_to do |format|
      if @business_hour.save
        format.json { render :show, status: :created }
      else
        format.json { render json: @business_hour.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /business_hours/1
  # PATCH/PUT /business_hours/1.json
  def update
    respond_to do |format|
      if @business_hour.update(business_hour_params)
        format.json { render :show, status: :ok }
      else
        format.json { render json: @business_hour.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /business_hours/1
  # DELETE /business_hours/1.json
  def destroy
    @business_hour.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_business
      @business = Business.find(params[:business_id])
    end

    def set_business_hour
      @business_hour = BusinessHour.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def business_hour_params
      params.require(:business_hour).permit(:day, :open, :close, :week_day) # can set the day either by index or name
    end
end

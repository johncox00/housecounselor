class BusinessesController < ApplicationController
  before_action :set_business, only: [:show, :edit, :update, :destroy]
  before_action :set_zip, only: [:create, :update]
  before_action :set_state, only: [:create, :update]
  before_action :set_city, only: [:create, :update]
  before_action :set_city_postal_code, only: [:create, :update]

  # GET /businesses
  # GET /businesses.json
  def index
    @businesses = Business.page(@page).per(@per)
  end

  # GET /businesses/1
  # GET /businesses/1.json
  def show
  end

  # GET /businesses/new
  def new
    @business = Business.new
  end

  # GET /businesses/1/edit
  def edit
  end

  # POST /businesses
  # POST /businesses.json
  def create
    @business = Business.new(modified_params.except(:work_types, :operating_cities))
    @business.work_types = WorkType.where(name: business_params[:work_types])
    @business.cities = City.where(name: business_params[:operating_cities])
    respond_to do |format|
      if @business.save
        format.json { render :show, status: :created, location: @business }
      else
        format.json { render json: @business.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /businesses/1
  # PATCH/PUT /businesses/1.json
  def update
    respond_to do |format|
      if @business.update(modified_params.except(:work_types, :operating_cities))
        if business_params[:work_types]
          @business.work_types = WorkType.where(name: business_params[:work_types])
          @business.cities = City.where(name: business_params[:operating_cities])
          @business.save
        end
        format.json { render :show, status: :ok, location: @business }
      else
        format.html { render :edit }
        format.json { render json: @business.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /businesses/1
  # DELETE /businesses/1.json
  def destroy
    @business.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_business
      @business = Business.find(params[:id])
    end

    def set_city
      @city = City.find_or_create_by(name: business_params[:address_attributes][:city], state: @state) if business_params[:address_attributes] && business_params[:address_attributes][:city]
    end

    def set_state
      @state = State.find_or_create_by(abbr: business_params[:address_attributes][:state]) if business_params[:address_attributes] && business_params[:address_attributes][:state]
    end

    def set_zip
      @zip = PostalCode.find_or_create_by(code: business_params[:address_attributes][:postal_code]) if business_params[:address_attributes] && business_params[:address_attributes][:postal_code]
    end

    def set_city_postal_code
      @city_postal_code = CityPostalCode.find_or_create_by(postal_code: @zip, city: @city) if @city && @zip
    end

    def modified_params
      if business_params[:address_attributes]
        new_params = business_params[:address_attributes].except(:city, :state, :postal_code)
        new_params[:city_id] = @city.id if business_params[:address_attributes][:city]
        new_params[:state_id] = @state.id if business_params[:address_attributes][:state]
        new_params[:postal_code_id] = @zip.id if business_params[:address_attributes][:postal_code]
        ret = business_params.dup
        ret[:address_attributes] = new_params
      else
        ret = business_params
      end
      return ret
    end

    # Only allow a list of trusted parameters through.
    def business_params
      params.require(:business).permit(:name, address_attributes: [:id, :line1, :line2, :city, :state, :postal_code], work_types: [], operating_cities: [])
    end
end

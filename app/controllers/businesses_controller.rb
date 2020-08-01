class BusinessesController < ApplicationController
  before_action :set_business, only: [:show, :edit, :update, :destroy]
  before_action :set_zip, only: [:create, :update]
  before_action :set_state, only: [:create, :update]
  before_action :set_city, only: [:create, :update]
  before_action :set_city_postal_code, only: [:create, :update]

  # GET /businesses
  # GET /businesses.json
  def index
    @businesses = Business.all

    ##  filtering  ##  NOTE: This would be more performant using Elasticsearch or similar
    if params[:name]
      @businesses = @businesses.where('LOWER(name) LIKE ?', "%#{params[:name].downcase}%")
    end
    if params[:open_at] || params[:open_days]
      hours = BusinessHour.all
      if params[:open_at]
        hours = hours.where('open <= ? AND close > ?', params[:open_at], params[:open_at])
      end
      if params[:open_days]
        days = params[:open_days].split(',')
        hours = hours.where(day: days)
      end
      @businesses = @businesses.where(id: hours.pluck(:business_id))
    end
    if params[:work_type]
      wt = WorkType.find_by_name(params[:work_type]).id
      @businesses = @businesses.where(id: BusinessWorkType.where(work_type_id: wt).pluck(:business_id))
    end
    if params[:postal_code]
      code = PostalCode.find_by_code(params[:postal_code])
      if code
        #find the cities this zip goes with
        city_ids = CityPostalCode.where(postal_code_id: code.id).pluck(:city_id)
        #find the business that operate in these cities
        business_ids = BusinessCity.where(city_id: city_ids).pluck(:business_id)
        @businesses = @businesses.where(id: business_ids)
      else
        @businesses = Business.where(id: -1)
      end
    end
    if params[:city]
      city = City.find_by_name(params[:city])
      if city
        business_ids = BusinessCity.where(city_id: city.id).pluck(:business_id)
        @businesses = @businesses.where(id: business_ids)
      else
        @businesses = Business.where(id: -1)
      end
    end
    if params[:rating]
      @businesses = @businesses.where('avg_rating >= ?', params[:rating])
    end


    ## sorting ##
    if params[:sort] == 'az'
      @businesses = @businesses.order('name ASC')
    elsif params[:sort] == 'za'
      @businesses = @businesses.order('name DESC')
    elsif params[:sort] == 'lohi'
      @businesses = @businesses.order('avg_rating ASC')
    elsif params[:sort] == 'hilo'
      @businesses = @businesses.order('avg_rating DESC')
    end

    @businesses = @businesses.page(@page).per(@per)
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
        end
        if business_params[:operating_cities]
          @business.cities = City.where(name: business_params[:operating_cities])
        end
        @business.save
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

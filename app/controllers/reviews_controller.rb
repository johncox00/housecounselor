class ReviewsController < ApplicationController
  before_action :set_business
  before_action :set_review, only: [:show, :edit, :update, :destroy]


  # GET /reviews
  # GET /reviews.json
  def index
    @reviews = @business.reviews.order(:created_at, :desc).page(@page).per(@per)
  end

  # GET /reviews/1
  # GET /reviews/1.json
  def show
  end

  # POST /reviews
  # POST /reviews.json
  def create
    @review = Review.new(review_params)
    @review.business = @business
    respond_to do |format|
      if @review.save
        format.json { render :show, status: :created }
      else
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reviews/1
  # PATCH/PUT /reviews/1.json
  def update
    respond_to do |format|
      if @review.update(review_params)
        format.json { render :show, status: :ok }
      else
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1
  # DELETE /reviews/1.json
  def destroy
    @review.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_business
      @business = Business.find(params[:business_id])
    end

    def set_review
      @review = @business.reviews.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def review_params
      params.require(:review).permit(:rating, :comment, :business_id)
    end
end

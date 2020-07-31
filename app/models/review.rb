class Review < ApplicationRecord
  belongs_to :business
  validates :rating, presence: true

  after_save :update_averge

  def update_averge
    sum = Review.where(business_id: self.business_id).sum(:rating)
    total = Review.where(business_id: self.business_id).count
    avg = sum.to_f / total.to_f 
    self.business.update(avg_rating: avg)
  end
end

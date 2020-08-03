class Review < ApplicationRecord
  belongs_to :business
  validates :rating, presence: true, :inclusion => {:in => [0,1,2,3,4,5]}

  after_save :update_averge

  def update_averge
    sum = Review.where(business_id: self.business_id).sum(:rating)
    total = Review.where(business_id: self.business_id).count
    avg = sum.to_f / total.to_f
    self.business.update(avg_rating: avg)
  end
end

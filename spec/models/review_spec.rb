require 'rails_helper'

RSpec.describe Review, type: :model do
  context 'validation' do
    it 'has a valid factory' do
      expect(FactoryBot.build(:review)).to be_valid
    end

    it 'requires a rating' do
      expect(FactoryBot.build(:review, rating: nil)).to_not be_valid
    end
  end

  context 'hooks' do
    it 'recalculates teh average rating for the business on save' do
      biz = FactoryBot.create(:business, avg_rating: 0)
      rev1 = FactoryBot.create(:review, rating: 1, business: biz)
      rev2 = FactoryBot.create(:review, rating: 4, business: biz)
      expect(biz.reload.avg_rating).to eq(2.5)
    end
  end
end

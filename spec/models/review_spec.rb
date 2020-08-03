require 'rails_helper'

RSpec.describe Review, type: :model do
  context 'validation' do
    it 'has a valid factory' do
      expect(FactoryBot.build(:review)).to be_valid
    end

    it 'requires a rating' do
      expect(FactoryBot.build(:review, rating: nil)).to_not be_valid
    end

    it 'checks that the rating is 0 - 5' do
      expect(FactoryBot.build(:review, rating: -1)).to_not be_valid
      expect(FactoryBot.build(:review, rating: 6)).to_not be_valid
      (0..5).each do |r|
        expect(FactoryBot.build(:review, rating: r)).to be_valid
      end
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

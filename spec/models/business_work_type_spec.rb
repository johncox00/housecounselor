require 'rails_helper'

RSpec.describe Business, type: :model do
  context 'validation' do
    it 'disallows assigning the same work type to a business multiple times' do
      b = FactoryBot.create(:business)
      wt = FactoryBot.create(:work_type)
      b.work_types << wt
      expect{b.work_types << wt}.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end

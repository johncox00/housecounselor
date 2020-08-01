require 'rails_helper'

RSpec.describe WorkType, type: :model do
  context 'validation' do
    it 'has a valid factory' do
      expect(FactoryBot.build(:work_type)).to be_valid
    end

    it 'requires a name' do
      expect(FactoryBot.build(:work_type, name: nil)).to_not be_valid
    end

    it 'requires name to be unique' do
      wt = FactoryBot.create(:work_type)
      expect(FactoryBot.build(:work_type, name: wt.name)).to_not be_valid
    end
  end
end

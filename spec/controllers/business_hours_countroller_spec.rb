require 'rails_helper'

RSpec.describe BusinessHoursController, type: :controller do
  let(:biz) { FactoryBot.create(:business) }
  let(:business_hour) { FactoryBot.create(:business_hour, business: biz) }

  let(:valid_attributes) {
    {
      week_day: "Sunday",
      open: 8,
      close: 6
    }
  }

  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      b = biz
      FactoryBot.create(:business_hour, business: b, day: 3)
      FactoryBot.create(:business_hour, business: b, day: 1)
      get :index, params: {business_id: b.id}, session: valid_session, format: :json
      resp = response
      expect(resp).to have_http_status(:success)
      expect(JSON.parse(resp.body).map{|x| x['day']}).to eq(['Monday', 'Wednesday'])
    end
  end

  describe "GET #show" do
    it "returns the thing" do
      r = business_hour
      get :show, params: {business_id: biz.id, id: r.id}, session: valid_session, format: :json
      expect(JSON.parse(response.body)['day']).to eq(WEEKDAYS[r.day])
    end

    it "returns a 404" do
      r = business_hour
      expect{get :show, params: {business_id: biz.id, id: 'bad'}, session: valid_session, format: :json}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new BusinessHour" do
        biz
        expect {
          post :create, params: {business_id: biz.id, business_hour: valid_attributes }, session: valid_session, format: :json
        }.to change(BusinessHour, :count).by(1)
      end
    end

  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { close: 9 }
      }

      it "updates the requested BusinessHour" do
        b = business_hour
        put :update, params: {business_id: biz.id, id: b.id, business_hour: new_attributes}, session: valid_session, format: :json
        b.reload
        expect(response).to have_http_status(:success)
        expect(b.close).to eq(9)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested BusinessHour" do
      business_hour
      expect {
        delete :destroy, params: {business_id: biz.id, id: business_hour.id}, session: valid_session, format: :json
      }.to change(BusinessHour, :count).by(-1)
    end
  end

end

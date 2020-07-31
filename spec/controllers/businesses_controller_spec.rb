require 'rails_helper'

RSpec.describe BusinessesController, type: :controller do
  let(:biz) { FactoryBot.create(:business) }

  let(:valid_attributes) {
    { name: "butch's flattops" }
  }

  let(:invalid_attributes) {
    { invalidparam: 'nothing' }
  }

  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      7.times{FactoryBot.create(:business)}
      get :index, params: {page: 2, per: 4}, session: valid_session, format: :json
      resp = response
      expect(resp).to have_http_status(:success)
      expect(JSON.parse(resp.body)['results'].length).to eq(3)
    end
  end

  describe "GET #show" do
    it "returns the thing" do
      b = biz
      get :show, params: {id: b.id}, session: valid_session, format: :json
      expect(JSON.parse(response.body)['name']).to eq(b.name)
    end

    it "returns a 404" do
      expect{get :show, params: {id: 'bad'}, session: valid_session, format: :json}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Business" do
        expect {
          post :create, params: {business: valid_attributes}, session: valid_session, format: :json
        }.to change(Business, :count).by(1)
      end
    end

    context "with invalid params" do
      it "doesn't create a new Business" do
        expect {
          post :create, params: {business: invalid_attributes}, session: valid_session, format: :json
        }.to change(Business, :count).by(0)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { name: 'Im another real neat Business' }
      }

      it "updates the requested Business" do
        b = biz
        put :update, params: {id: b.id, business: new_attributes}, session: valid_session, format: :json
        b.reload
        expect(response).to have_http_status(:success)
        expect(b.name).to eq('Im another real neat Business')
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested Business" do
      biz
      expect {
        delete :destroy, params: {id: biz.id}, session: valid_session, format: :json
      }.to change(Business, :count).by(-1)
    end
  end

end

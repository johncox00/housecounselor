require 'rails_helper'

RSpec.describe WorkTypesController, type: :controller do
  let(:wt) { FactoryBot.create(:work_type) }

  let(:valid_attributes) {
    { name: "wrenching" }
  }

  let(:invalid_attributes) {
    { invalidparam: 'nothing' }
  }

  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      7.times{FactoryBot.create(:work_type)}
      get :index, params: {page: 2, per: 4}, session: valid_session, format: :json
      resp = response
      expect(resp).to have_http_status(:success)
      expect(JSON.parse(resp.body)['results'].length).to eq(3)
    end
  end

  describe "GET #show" do
    it "returns the thing" do
      b = wt
      get :show, params: {id: b.id}, session: valid_session, format: :json
      expect(JSON.parse(response.body)['name']).to eq(b.name)
    end

    it "returns a 404" do
      expect{get :show, params: {id: 'bad'}, session: valid_session, format: :json}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new WorkType with an address" do
        expect {
          post :create, params: {work_type: valid_attributes}, session: valid_session, format: :json
        }.to change(WorkType, :count).by(1)
      end
    end

    context "with invalid params" do
      it "doesn't create a new WorkType" do
        expect {
          post :create, params: {work_type: invalid_attributes}, session: valid_session, format: :json
        }.to change(WorkType, :count).by(0)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { name: 'Im another real neat WorkType' }
      }

      it "updates the requested WorkType" do
        b = wt
        put :update, params: {id: b.id, work_type: new_attributes}, session: valid_session, format: :json
        b.reload
        expect(response).to have_http_status(:success)
        expect(b.name).to eq('Im another real neat WorkType')
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested WorkType" do
      wt
      expect {
        delete :destroy, params: {id: wt.id}, session: valid_session, format: :json
      }.to change(WorkType, :count).by(-1)
    end
  end

end

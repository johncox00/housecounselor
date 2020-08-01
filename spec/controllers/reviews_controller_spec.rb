require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do
  let(:biz) { FactoryBot.create(:business) }
  let(:review) { FactoryBot.create(:review, business: biz) }

  let(:valid_attributes) {
    {
      comment: "best flattop ever!",
      rating: 4
    }
  }

  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      b = biz
      7.times{FactoryBot.create(:review, business: b)}
      get :index, params: {page: 2, per: 4, business_id: b.id}, session: valid_session, format: :json
      resp = response
      expect(resp).to have_http_status(:success)
      expect(JSON.parse(resp.body)['results'].length).to eq(3)
    end
  end

  describe "GET #show" do
    it "returns the thing" do
      r = review
      get :show, params: {business_id: biz.id, id: r.id}, session: valid_session, format: :json
      expect(JSON.parse(response.body)['comment']).to eq(r.comment)
    end

    it "returns a 404" do
      r = review
      get :show, params: {business_id: biz.id, id: 'bad'}, session: valid_session, format: :json
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Review" do
        biz
        expect {
          post :create, params: {business_id: biz.id, review: valid_attributes }, session: valid_session, format: :json
        }.to change(Review, :count).by(1)
      end
    end

  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { comment: 'whoops, wrong comment' }
      }

      it "updates the requested Review" do
        b = review
        put :update, params: {business_id: biz.id, id: b.id, review: new_attributes}, session: valid_session, format: :json
        b.reload
        expect(response).to have_http_status(:success)
        expect(b.comment).to eq('whoops, wrong comment')
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested Review" do
      review
      expect {
        delete :destroy, params: {business_id: biz.id, id: review.id}, session: valid_session, format: :json
      }.to change(Review, :count).by(-1)
    end
  end

end

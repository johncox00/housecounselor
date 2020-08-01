require 'rails_helper'

RSpec.describe BusinessesController, type: :controller do
  let(:biz) { FactoryBot.create(:business) }

  let(:valid_attributes) {
    {
      name: "butch's flattops",
      address_attributes: {
        line1: '123 main st',
        line2: 'apt 2',
        city: 'Littleton',
        state: 'CO',
        postal_code: '80126'
      },
      work_types: [
        'Construct',
        'Destroy',
        'Not real'
      ],
      operating_cities: [
        'Highlands Ranch',
        'Littleton',
        'Centennial'
      ]
    }
  }

  let(:invalid_attributes) {
    { invalidparam: 'nothing' }
  }

  let(:valid_session) { {} }

  before do
    WorkType.find_or_create_by(name: 'Construct')
    WorkType.find_or_create_by(name: 'Destroy')
    WorkType.find_or_create_by(name: 'Clean')
    state = State.find_or_create_by(abbr: 'CO')
    [
      'Highlands Ranch',
      'Littleton',
      'Centennial'
    ].each{|c| City.find_or_create_by(name: c, state: state)}

  end

  describe "GET #index" do
    it "returns a success response" do
      7.times{FactoryBot.create(:business)}
      get :index, params: {page: 2, per: 4}, session: valid_session, format: :json
      resp = response
      expect(resp).to have_http_status(:success)
      expect(JSON.parse(resp.body)['results'].length).to eq(3)
    end
    context 'sorting' do
      it 'sorts a-z' do
        b1 = FactoryBot.create(:business, name: "B")
        b2 = FactoryBot.create(:business, name: "C")
        b3 = FactoryBot.create(:business, name: "A")
        get :index, params: {sort: 'az'}, session: valid_session, format: :json
        expect(JSON.parse(response.body)['results'].map{|x| x['id']}).to eq([b3, b1, b2].map{|x| x.id})
      end

      it 'sorts z-a' do
        b1 = FactoryBot.create(:business, name: "Y")
        b2 = FactoryBot.create(:business, name: "Z")
        b3 = FactoryBot.create(:business, name: "X")
        get :index, params: {sort: 'za'}, session: valid_session, format: :json
        expect(JSON.parse(response.body)['results'].map{|x| x['id']}).to eq([b2, b1, b3].map{|x| x.id})
      end

      it 'sorts by rating ascending' do
        b1 = FactoryBot.create(:business, avg_rating: 3)
        b2 = FactoryBot.create(:business, avg_rating: 2)
        b3 = FactoryBot.create(:business, avg_rating: 1)
        get :index, params: {sort: 'lohi'}, session: valid_session, format: :json
        expect(JSON.parse(response.body)['results'].map{|x| x['id']}).to eq([b3, b2, b1].map{|x| x.id})
      end

      it 'sorts by rating ascending' do
        b1 = FactoryBot.create(:business, avg_rating: 3)
        b2 = FactoryBot.create(:business, avg_rating: 1)
        b3 = FactoryBot.create(:business, avg_rating: 2)
        get :index, params: {sort: 'hilo'}, session: valid_session, format: :json
        expect(JSON.parse(response.body)['results'].map{|x| x['id']}).to eq([b1, b3, b2].map{|x| x.id})
      end
    end

    context 'filtering' do
      it 'filters by name' do
        b1 = FactoryBot.create(:business, name: "Yazoo")
        b2 = FactoryBot.create(:business, name: "Yaz")
        b3 = FactoryBot.create(:business, name: "X-Stacey")
        get :index, params: {name: 'yaz'}, session: valid_session, format: :json
        expect(JSON.parse(response.body)['results'].map{|x| x['id']}.sort).to eq([b1, b2].map{|x| x.id}.sort)
      end

      it 'filters by business hours' do
        b1 = FactoryBot.create(:business)
        b2 = FactoryBot.create(:business)
        FactoryBot.create(:business_hour, business: b1, day: 1, open: 9, close: 17)
        FactoryBot.create(:business_hour, business: b1, day: 3, open: 9, close: 17)
        FactoryBot.create(:business_hour, business: b1, day: 5, open: 9, close: 17)
        FactoryBot.create(:business_hour, business: b2, day: 2, open: 8, close: 18)
        FactoryBot.create(:business_hour, business: b2, day: 4, open: 8, close: 18)
        FactoryBot.create(:business_hour, business: b2, day: 5, open: 8, close: 18)
        get :index, params: {open_at: 12}, session: valid_session, format: :json
        expect(JSON.parse(response.body)['results'].map{|x| x['id']}.sort).to eq([b1, b2].map{|x| x.id}.sort)
        get :index, params: {open_days: 1}, session: valid_session, format: :json
        expect(JSON.parse(response.body)['results'].map{|x| x['id']}.sort).to eq([b1].map{|x| x.id}.sort)
        get :index, params: {open_days: '1,2'}, session: valid_session, format: :json
        expect(JSON.parse(response.body)['results'].map{|x| x['id']}.sort).to eq([b1, b2].map{|x| x.id}.sort)
      end

      it 'filters by work_types' do
        b1 = FactoryBot.create(:business)
        b2 = FactoryBot.create(:business)
        j1 = FactoryBot.create(:work_type, name: 'foo')
        j2 = FactoryBot.create(:work_type, name: 'bar')
        j3 = FactoryBot.create(:work_type, name: 'baz')
        b1.work_types = [j1, j2]
        b2.work_types = [j2, j3]
        get :index, params: {work_type: 'foo'}, session: valid_session, format: :json
        expect(JSON.parse(response.body)['results'].map{|x| x['id']}.sort).to eq([b1].map{|x| x.id}.sort)
        get :index, params: {work_type: 'bar'}, session: valid_session, format: :json
        expect(JSON.parse(response.body)['results'].map{|x| x['id']}.sort).to eq([b1, b2].map{|x| x.id}.sort)
      end

      context 'geography' do
        let(:state){State.find_or_create_by(abbr: 'CO')}
        let(:code1){FactoryBot.create(:postal_code, code: '80126')}
        let(:city1){City.find_by_name('Littleton') || FactoryBot.create(:city, name: 'Littleton', state: state)}
        let(:city2){City.find_by_name('Highlands Ranch') || FactoryBot.create(:city, name: 'Highlands Ranch', state: state)}
        let(:code2){FactoryBot.create(:postal_code, code: '80216')}
        let(:city3){City.find_by_name('Denver') || FactoryBot.create(:city, name: 'Denver')}
        let(:b1){FactoryBot.create(:business)}
        let(:b2){FactoryBot.create(:business)}
        let(:b3){FactoryBot.create(:business)}
        let(:code3){FactoryBot.create(:postal_code, code: '80127')}

        before :each do
          state
          code1
          city1
          city2
          code2
          city3
          code3
          b1
          b2
          b3
          code1.cities = [city1, city2]
          code2.cities = [city3]
          code3.cities = [city2]
          b1.cities = [city1, city3]
          b2.cities = [city2, city3]
          b3.cities = [city2]
        end

        it 'filers by postal code' do
          get :index, params: {postal_code: '80127'}, session: valid_session, format: :json
          expect(JSON.parse(response.body)['results'].map{|x| x['id']}.sort).to eq([b2, b3].map{|x| x.id}.sort)
          get :index, params: {postal_code: '80126'}, session: valid_session, format: :json
          expect(JSON.parse(response.body)['results'].map{|x| x['id']}.sort).to eq([b1, b2, b3].map{|x| x.id}.sort)
          get :index, params: {postal_code: '80216'}, session: valid_session, format: :json
          expect(JSON.parse(response.body)['results'].map{|x| x['id']}.sort).to eq([b1, b2].map{|x| x.id}.sort)
          get :index, params: {postal_code: '80909'}, session: valid_session, format: :json
          expect(JSON.parse(response.body)['results'].length).to eq(0)
        end

        it 'filters by city name' do
          get :index, params: {city: 'Littleton'}, session: valid_session, format: :json
          expect(JSON.parse(response.body)['results'].map{|x| x['id']}.sort).to eq([b1].map{|x| x.id}.sort)
        end
      end

      it 'filters by rating' do
        b1 = FactoryBot.create(:business, avg_rating: 2.2)
        b2 = FactoryBot.create(:business, avg_rating: 3.1)
        b3 = FactoryBot.create(:business, avg_rating: 4.2)
        b4 = FactoryBot.create(:business, avg_rating: 5)

        get :index, params: {rating: 2}, session: valid_session, format: :json
        expect(JSON.parse(response.body)['results'].map{|x| x['id']}.sort).to eq([b1, b2, b3, b4].map{|x| x.id}.sort)
        get :index, params: {rating: 3}, session: valid_session, format: :json
        expect(JSON.parse(response.body)['results'].map{|x| x['id']}.sort).to eq([b2, b3, b4].map{|x| x.id}.sort)
        get :index, params: {rating: 4}, session: valid_session, format: :json
        expect(JSON.parse(response.body)['results'].map{|x| x['id']}.sort).to eq([b3, b4].map{|x| x.id}.sort)
        get :index, params: {rating: 5}, session: valid_session, format: :json
        expect(JSON.parse(response.body)['results'].map{|x| x['id']}.sort).to eq([b4].map{|x| x.id}.sort)
      end
    end

  end

  describe "GET #show" do
    it "returns the thing" do
      b = biz
      FactoryBot.create(:business_hour, business: b)
      get :show, params: {id: b.id}, session: valid_session, format: :json
      json = JSON.parse(response.body)
      expect(json['name']).to eq(b.name)
      expect(json['business_hours'].length).to eq(1)
    end

    it "returns a 404" do
      get :show, params: {id: 'bad'}, session: valid_session, format: :json
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Business with an address" do
        expect {
          post :create, params: {business: valid_attributes}, session: valid_session, format: :json
          json = JSON.parse(response.body)
          expect(json['address_attributes']['postal_code']).to eq('80126')
          expect(json['work_types'].length).to eq(2)
          expect(json['operating_cities'].length).to eq(3)
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

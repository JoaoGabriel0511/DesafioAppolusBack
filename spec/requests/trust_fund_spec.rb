require 'rails_helper'

RSpec.describe "TrustFunds", type: :request do

  before do
    @user = User.create(name: "jhon", email: "jhon@email.com", password: "12345678", password_confirmation: "12345678")
    post '/api/v1/auth', params: {email: "jhon@email.com", password: "12345678"}
    @token = JSON.parse(response.body)["token"]
  end

  describe "GET /index" do

    before do
      10.times do
        TrustFund.create(name: "Tesouro Selic", fund_type: TrustFund.fund_types[:STOCK], user: @user)
      end
    end

    it "returns all created trust funds" do
      get '/api/v1/trust_funds', headers: {"Authorization"  => @token}
      data = JSON.parse(response.body)["data"]
      message = JSON.parse(response.body)["message"]
      expect(response).to have_http_status(:success)
      expect(message).to eq("trust funds recovered")
      expect(data["trust_funds"]).to have_attributes(size: 10)
    end

  end

  describe "POST /create" do

    it "returns http success with the trust_fund attributes when creating a valid user" do
      post '/api/v1/trust_fund', params: {trust_fund: {name: "Tesouro Selic", fund_type: "STOCK"}} , headers: {"Authorization"  => @token}
      data = JSON.parse(response.body)["data"]
      message = JSON.parse(response.body)["message"]
      expect(response).to have_http_status(:success)
      expect(message).to eq("trust fund created")
      expect(data["trust_fund"]["name"]).to eq("Tesouro Selic")
      expect(data["trust_fund"]["fund_type"]).to eq("STOCK")
      expect(data["trust_fund"]["fund_value"]).to eq(0)
      expect(data["trust_fund"]["user_id"]).to eq(@user.id)
    end

  end
end

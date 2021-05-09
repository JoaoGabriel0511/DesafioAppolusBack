require 'rails_helper'

RSpec.describe "TrustFunds", type: :request do

  before do
    @user = User.create(name: "jhon", email: "jhon@email.com", password: "12345678", password_confirmation: "12345678")
    @account = Account.create(user: @user, balance: 500)
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

  describe "POST /invest_value" do

    before do
      @trust_fund = TrustFund.create(name: "Tesouro Selic", fund_type: TrustFund.fund_types[:STOCK], user: @user)
    end

    it "creates an investment in a trust fund" do
      post '/api/v1/trust_fund/invest', params: {investment: {value: 40.0, trust_fund_id: @trust_fund.id}}, headers: {"Authorization"  => @token}
      data = JSON.parse(response.body)["data"]
      message = JSON.parse(response.body)["message"]
      expect(response).to have_http_status(:success)
      expect(message).to eq("value invested")
      expect(data["investment"]["account_id"]).to eq(@account.id)
      expect(data["investment"]["trust_fund_id"]).to eq(@trust_fund.id)
      expect(data["investment"]["value"]).to eq(40.0)
      expect(data["account"]["id"]).to eq(@account.id)
      expect(data["account"]["balance"]).to eq(460.0)
    end

    it "returns a error message when investment value is greater then the account balance" do
      post '/api/v1/trust_fund/invest', params: {investment: {value: 540.0, trust_fund_id: @trust_fund.id}}, headers: {"Authorization"  => @token}
      errors = JSON.parse(response.body)["errors"]
      expect(response).to have_http_status(:unprocessable_entity)
      expect(errors["value"]).to eq(["Cant invest greater the user account balance"])
    end

    it "returns a error message when investment params are invalid" do
      post '/api/v1/trust_fund/invest', params: {investment: {value: 40.0}}, headers: {"Authorization"  => @token}
      errors = JSON.parse(response.body)["errors"]
      expect(response).to have_http_status(:unprocessable_entity)
      expect(errors["trust_fund"]).to eq(["must exist"])
    end

  end

  describe "POST /withdraw_value" do

    before do
      @trust_fund = TrustFund.create(name: "Tesouro Selic", fund_type: TrustFund.fund_types[:STOCK], user: @user)
      @investment = Investment.create(account: @account, trust_fund: @trust_fund, value: 400.0)
    end

    it "creates an investment in a trust fund" do
      post '/api/v1/trust_fund/withdraw', params: {investment: {value: 40.0, trust_fund_id: @trust_fund.id}}, headers: {"Authorization"  => @token}
      data = JSON.parse(response.body)["data"]
      message = JSON.parse(response.body)["message"]
      expect(response).to have_http_status(:success)
      expect(message).to eq("value withdrawn")
      expect(data["investment"]["account_id"]).to eq(@account.id)
      expect(data["investment"]["trust_fund_id"]).to eq(@trust_fund.id)
      expect(data["investment"]["value"]).to eq(360.0)
      expect(data["account"]["id"]).to eq(@account.id)
      expect(data["account"]["balance"]).to eq(540.0)
    end

    it "returns a error message when investment value is greater then the account balance" do
      post '/api/v1/trust_fund/withdraw', params: {investment: {value: 440.0, trust_fund_id: @trust_fund.id}}, headers: {"Authorization"  => @token}
      errors = JSON.parse(response.body)["errors"]
      expect(response).to have_http_status(:unprocessable_entity)
      expect(errors["value"]).to eq(["Cant withdraw a value greater then the investment value"])
    end


  end


end

require 'rails_helper'

RSpec.describe "Account", type: :request do

  before do
    @user = User.create(name: "jhon", email: "jhon@email.com", password: "12345678", password_confirmation: "12345678")
    @account = Account.create(user_id: @user.id, balance: 500.0)
    post '/api/v1/auth', params: {email: "jhon@email.com", password: "12345678"}
    @token = JSON.parse(response.body)["token"]
  end

  describe 'Get /index' do

    before do
      10.times do |it|
        if(it.odd?)
          Transaction.create(transaction_type: Transaction.transaction_types[:WITHDRAW], account_id: @account.id, value: 0.0, balance: @account.balance)
        else
          Transaction.create(transaction_type: Transaction.transaction_types[:DEPOSIT], account_id: @account.id, value: 0.0, balance: @account.balance)
        end
      end
    end

    it "return http success and the user data when the token is valid" do
      get '/api/v1/account', headers: {"Authorization"  => @token}
      data = JSON.parse(response.body)["data"]
      message = JSON.parse(response.body)["message"]
      expect(response).to have_http_status(:success)
      expect(data["user"]["name"]).to eq 'jhon'
      expect(data["user"]["email"]).to eq 'jhon@email.com'
      expect(data["account"]["balance"]).to eq 500.0
      expect(message).to eq 'user jhon@email.com retrieved'
    end

    it "return http success and the user data when the token is valid" do
      get '/api/v1/account'
      expect(response).to have_http_status(:unauthorized)
    end

    it "deposits values to the account balance" do
      expect(@account.balance).to eq(500.0)
      post '/api/v1/account/deposit', headers: {"Authorization"  => @token}, params: {deposit: {value: 100.0}}
      expect(response).to have_http_status(:success)
      data = JSON.parse(response.body)["data"]
      message = JSON.parse(response.body)["message"]
      expect(data["account"]["balance"]).to eq 600.0
      expect(data["transaction"]["balance"]).to eq 600.0
      expect(data["transaction"]["transaction_type"]).to eq "DEPOSIT"
      expect(data["transaction"]["value"]).to eq 100.0
      expect(data["transaction"]["account_id"]).to eq @account.id
      expect(message).to eq 'Deposit made to account'
    end

    it "withdraw values from the account balance" do
      expect(@account.balance).to eq(500.00)
      post '/api/v1/account/withdraw', headers: {"Authorization"  => @token}, params: {withdraw: {value: 100.0}}
      expect(response).to have_http_status(:success)
      data = JSON.parse(response.body)["data"]
      message = JSON.parse(response.body)["message"]
      expect(data["account"]["balance"]).to eq 400.0
      expect(data["transaction"]["balance"]).to eq 400.0
      expect(data["transaction"]["transaction_type"]).to eq "WITHDRAW"
      expect(data["transaction"]["value"]).to eq 100.0
      expect(data["transaction"]["account_id"]).to eq @account.id
      expect(message).to eq 'Withdraw made from account'
    end

    it "recovers the account statement" do
      get '/api/v1/account/statement', headers: {"Authorization" => @token}
      expect(response).to have_http_status(:success)
      data = JSON.parse(response.body)["data"]
      expect(data["account_statement"]).to have_attributes(size: 10)
    end

    it "return a error message when it tries to withdraw a value greater then the balance" do
      expect(@account.balance).to eq(500.00)
      post '/api/v1/account/withdraw', headers: {"Authorization"  => @token}, params: {withdraw: {value: 600.0}}
      expect(response).to have_http_status(:not_acceptable)
      error = JSON.parse(response.body)["error"]
      expect(error).to eq "User can`t withdraw a value greater than the balance"
    end

  end

  describe "GET /account_investments" do

    before do
      @trust_fund = TrustFund.create(name: "Tesouro Selic", fund_type: TrustFund.fund_types[:STOCK], user: @user)
      @investment = Investment.create(account: @account, trust_fund: @trust_fund, value: 400.0)
    end

    it "returns all of the account investments" do
      get '/api/v1/account/investments', headers: {"Authorization"  => @token}
      expect(response).to have_http_status(:success)
    end

  end

end

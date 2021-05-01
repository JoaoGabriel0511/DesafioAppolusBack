require 'rails_helper'

RSpec.describe "Account", type: :request do

  describe 'Get /index' do

    before do
      user = User.create(name: "jhon", email: "jhon@email.com", password: "12345678", password_confirmation: "12345678")
      Account.create(user_id: user.id)
      post '/api/v1/auth', params: {email: "jhon@email.com", password: "12345678"}
      @token = JSON.parse(response.body)["token"]
    end

    it "return http success and the user data when the token is valid" do
      get '/api/v1/account', headers: {"Authorization"  => @token}
      data = JSON.parse(response.body)["data"]
      message = JSON.parse(response.body)["message"]
      expect(response).to have_http_status(:success)
      expect(data["user"]["name"]).to eq 'jhon'
      expect(data["user"]["email"]).to eq 'jhon@email.com'
      expect(data["account"]["balance"]).to eq 0.0
      expect(message).to eq 'user jhon@email.com retrieved'
    end

    it "return http success and the user data when the token is valid" do
      get '/api/v1/account'
      expect(response).to have_http_status(:unauthorized)
    end

  end

end

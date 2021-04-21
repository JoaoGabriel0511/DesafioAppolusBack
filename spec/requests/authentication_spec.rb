require 'rails_helper'

RSpec.describe "Authentication", type: :request do

  describe "Post /create" do

    before do
      User.create(name: "jhon", email: "jhon@email.com", password: "12345678", password_confirmation: "12345678")
    end

    it "returns http status success with an authentication token when the email exists and the password is valid " do
      post '/api/v1/auth', params: {email: "jhon@email.com", password: "12345678"}
      data = JSON.parse(response.body)
      expect(response).to have_http_status(:success)
      expect(data.keys).to contain_exactly("token")
    end

    it "return http status unauthorized when the email does not exist" do
      post '/api/v1/auth', params: {email: "joe@email.com", password: "12345678"}
      data = JSON.parse(response.body)
      expect(response).to have_http_status(:unauthorized)
      expect(data["errors"]).to eq "invalid login"
    end

    it "return http status unauthorized when the password does not match" do
      post '/api/v1/auth', params: {email: "jhon@email.com", password: "12345679"}
      data = JSON.parse(response.body)
      expect(response).to have_http_status(:unauthorized)
      expect(data["errors"]).to eq "invalid login"
    end

  end

end

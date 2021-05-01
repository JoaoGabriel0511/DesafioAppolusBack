require 'rails_helper'

RSpec.describe "Users", type: :request do

  describe 'Put /update' do

    before do
      User.create(name: "jhon", email: "jhon@email.com", password: "12345678", password_confirmation: "12345678")
      post '/api/v1/auth', params: {email: "jhon@email.com", password: "12345678"}
      @token = JSON.parse(response.body)["token"]
    end

    it "return http success and the updated user data when the token is valid" do
      put '/api/v1/user', params: { user: { name: 'joe', email: 'joe@email.com', password: '12345679', password_confirmation: '12345679' }}, headers: { "Authorization"  => @token}
      data = JSON.parse(response.body)["data"]
      message = JSON.parse(response.body)["message"]
      expect(response).to have_http_status(:success)
      expect(data["user"]["name"]).to eq 'joe'
      expect(data["user"]["email"]).to eq 'joe@email.com'
      expect(message).to eq 'user updated'
    end

    it "return http success and the updated user data when the token is valid" do
      put '/api/v1/user', params: { user: { email: 'joeemail.com', password: '12345679', password_confirmation: '123456' }}, headers: { "Authorization"  => @token}
      errors = JSON.parse(response.body)["errors"]
      message = JSON.parse(response.body)["message"]
      expect(response).to have_http_status(:unprocessable_entity)
      expect(errors["password_confirmation"]).to eq ["doesn't match Password"]
      expect(errors["email"]).to eq ["is invalid"]
      expect(message).to eq 'user not updated'
    end

    it "return http unauthorized if no token is set on header" do
      put '/api/v1/user', params: { user: { name: 'joe', email: 'joe@email.com', password: '12345679', password_confirmation: '12345679' }}
      expect(response).to have_http_status(:unauthorized)
    end

  end

  describe 'Delete /destroy' do
    before do
      User.create(name: "jhon", email: "jhon@email.com", password: "12345678", password_confirmation: "12345678")
      post '/api/v1/auth', params: {email: "jhon@email.com", password: "12345678"}
      @token = JSON.parse(response.body)["token"]
    end

    it "returns http success with the deleted user data when the token is valid" do
      delete '/api/v1/user', headers: {"Authorization"  => @token}
      expect(response).to have_http_status(:success)
      data = JSON.parse(response.body)["data"]
      message = JSON.parse(response.body)["message"]
      expect(data["user"]["name"]).to eq "jhon"
      expect(data["user"]["email"]).to eq "jhon@email.com"
      expect(message).to eq "user deleted"
    end

    it "return http unauthorized if no token is set on header" do
      delete '/api/v1/user'
      expect(response).to have_http_status(:unauthorized)
    end

  end

end

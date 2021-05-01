require 'rails_helper'

RSpec.describe "Registrations", type: :request do
  describe "Post /create" do

    it "returns http success with the user attributes when creating a valid user" do
      post '/users', params: { user: { name: 'jhon', email: 'jhon@email.com', password: '12345678', password_confirmation: '12345678' }}
      data = JSON.parse(response.body)["data"]
      expect(response).to have_http_status(:success)
      expect(data["user"]["name"]).to eq 'jhon'
      expect(data["user"]["email"]).to eq 'jhon@email.com'
      expect(data["account"]["balance"]).to eq 0.0
      expect(data["account"]["user_id"]).to eq data["user"]["id"]
    end

    it "return http unprocessable_entity with the validation errors when creating an invalid user" do
      post '/users', params: { user: { email: 'jhonemail.com', password: '12345679', password_confirmation: '12345678' }}
      errors = JSON.parse(response.body)["errors"]
      expect(response).to have_http_status(:unprocessable_entity)
      expect(errors["name"]).to eq ["can't be blank"]
      expect(errors["email"]).to eq ["is invalid"]
      expect(errors["password_confirmation"]).to eq ["doesn't match Password"]
    end

  end
end
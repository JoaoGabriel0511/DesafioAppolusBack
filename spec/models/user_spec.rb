require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with valid attributes" do
    expect(User.new(name: "jhon", email: "jhon@email.com", password: "12345678", password_confirmation: "12345678")).to be_valid
  end

  it "is not valid without a name" do
    expect(User.new(email: "jhon@email.com", password: "12345678", password_confirmation: "12345678")).to_not be_valid
  end

  it "is not valid with invalid email" do
    expect(User.new(name: "jhon", email: "jhonemail.com", password: "12345678", password_confirmation: "12345678")).to_not be_valid
    expect(User.new(name: "jhon", password: "12345678", password_confirmation: "12345678")).to_not be_valid
  end

  it "is not valid without unique email" do
    User.create(name: "jhon", email: "jhon@email.com", password: "12345678", password_confirmation: "12345678")
    expect(User.new(name: "joe", email: "jhon@email.com", password: "12345678", password_confirmation: "12345678")).to_not be_valid
  end

  it "is not valid with invalid password" do
    expect(User.new(name: "jhon", email: "jhon@email.com")).to_not be_valid
    expect(User.new(name: "jhon", email: "jhon@email.com", password: "123", password_confirmation: "123")).to_not be_valid
    expect(User.new(name: "jhon", email: "jhon@email.com", password: "12345679", password_confirmation: "12345678")).to_not be_valid
  end

end


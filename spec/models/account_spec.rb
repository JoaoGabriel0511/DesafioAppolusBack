require 'rails_helper'

RSpec.describe Account, type: :model do

  before do
    @user = User.create(name: "jhon", email: "jhon@email.com", password: "12345678", password_confirmation: "12345678")
  end

  it "is valid with an user and its balance default value is 0" do
    account = Account.new(user_id: @user.id)
    expect(account).to be_valid
    expect(account.balance).to eq 0.0
  end

  it "is invalid without an user" do
    account = Account.new
    expect(account).to_not be_valid
  end
  
  it "is valid with balance greater or equal to 0"  do
    account = Account.new(user_id: @user.id, balance: 1.0)
    expect(account).to be_valid
  end

  it "is invalid with balance less than 0"  do
    account = Account.new(user_id: @user.id, balance: -1.0)
    expect(account).to_not be_valid
  end

  it "is invalid if user already have another account" do
    Account.create(user_id: @user.id)
    account = Account.new(user_id: @user.id)
    expect(account).to_not be_valid
  end

end

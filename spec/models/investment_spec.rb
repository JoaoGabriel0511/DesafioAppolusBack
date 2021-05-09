require 'rails_helper'

RSpec.describe Investment, type: :model do

  before do
    @user1 = User.create(name: "jhon", email: "jhon@email.com", password: "12345678", password_confirmation: "12345678")
    @account1 = Account.create(user: @user1)
    @user2 = User.create(name: "joe", email: "joe@email.com", password: "12345678", password_confirmation: "12345678")
    @account2 = Account.create(user: @user2)
    @trust_fund = TrustFund.create(name: "Tesouro Selic", fund_type: TrustFund.fund_types[:STOCK], user: @user1)
    Investment.create(account: @account2, trust_fund: @trust_fund)
  end

  it "should create a valid investment with valid params with its value column with 0 as default" do
    investment = Investment.new(account: @account1, trust_fund: @trust_fund)
    expect(investment).to be_valid
    expect(investment.value).to eq(0.0)
  end

  it "should not be valid investment without a trust_fund" do
    investment = Investment.new(account: @account1)
    expect(investment).to_not be_valid
  end

  it "should not be valid investment without an account" do
    investment = Investment.new(trust_fund: @trust_fund)
    expect(investment).to_not be_valid
  end

  it "should not be valid without user trust_fund pair" do
    investment = Investment.new(account: @account2, trust_fund: @trust_fund)
    expect(investment).to_not be_valid
  end

end

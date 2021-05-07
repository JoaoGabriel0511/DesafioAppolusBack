require 'rails_helper'

RSpec.describe TrustFund, type: :model do

  before do
    @user = User.create(name: "jhon", email: "jhon@email.com", password: "12345678", password_confirmation: "12345678")
  end

  it "is valid with valid params and its fund_value default value is 0" do
    trust_fund = TrustFund.new(name: "Tesouro Selic", fund_type: TrustFund.fund_types[:STOCK], user: @user)
    expect(trust_fund).to be_valid
    expect(trust_fund.fund_value).to be(0.0)
  end

  it "is invalid without a name" do
    trust_fund = TrustFund.new(fund_type: TrustFund.fund_types[:STOCK], user: @user)
    expect(trust_fund).to_not be_valid
  end

  it "is invalid without a fund_type" do
    trust_fund = TrustFund.new(name: "Tesouro Selic", user: @user)
    expect(trust_fund).to_not be_valid
  end

  it "is invalid without a user" do
    trust_fund = TrustFund.new(name: "Tesouro Selic", fund_type: TrustFund.fund_types[:STOCK])
    expect(trust_fund).to_not be_valid
  end

end

require 'rails_helper'

RSpec.describe Transaction, type: :model do

  before do
    @user = User.create(name: "jhon", email: "jhon@email.com", password: "12345678", password_confirmation: "12345678")
    @account = Account.create(user_id: @user.id)
  end

  it "is valid with valid params" do
    type = Transaction.transaction_types[:DEPOSIT]
    transaction = Transaction.new(transaction_type: type, value: 0.0, balance: 0.0, account_id: @account.id)
    expect(transaction).to be_valid
  end

  it "is invalid without a transaction type" do
    transaction = Transaction.new(value: 0.0, balance: 0.0, account_id: @account.id)
    expect(transaction).to_not be_valid
  end

  it "is invalid without a value" do
    type = Transaction.transaction_types[:DEPOSIT]
    transaction = Transaction.new(transaction_type: type, balance: 0.0, account_id: @account.id)
    expect(transaction).to_not be_valid
  end

  it "is invalid without a balance" do
    type = Transaction.transaction_types[:DEPOSIT]
    transaction = Transaction.new(transaction_type: type, value: 0.0, account_id: @account.id)
    expect(transaction).to_not be_valid
  end

  it "is invalid without an account" do
    type = Transaction.transaction_types[:DEPOSIT]
    transaction = Transaction.new(transaction_type: type, value: 0.0, balance: 0.0)
    expect(transaction).to_not be_valid
  end

end

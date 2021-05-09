class Transaction < ApplicationRecord
  belongs_to :account
  enum transaction_type: [:DEPOSIT, :WITHDRAW, :INVEST, :INVEST_WITHDRAWN]
  validates :transaction_type, :balance, :value, presence: true
  has_one :trust_fund
end

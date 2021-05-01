class Transaction < ApplicationRecord
  belongs_to :account
  enum transaction_type: [:DEPOSIT, :WITHDRAW]
  validates :transaction_type, :balance, :value, presence: true
end

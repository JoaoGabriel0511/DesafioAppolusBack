class Account < ApplicationRecord
  belongs_to :user
  validates :balance, numericality: {greater_than_or_equal_to: 0}
  validates_uniqueness_of :user_id
  has_many :transactions

  def deposit(value)
    self.balance += value
  end

  def withdraw(value)
    self.balance -= value
  end
end

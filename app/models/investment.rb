class Investment < ApplicationRecord
  belongs_to :user
  belongs_to :trust_fund
  validates :value, numericality: {greater_than_or_equal_to: 0}
  validates :user_id, uniqueness: { scope: :trust_fund_id }

  def deposit(value)
    self.value += value
  end

  def withdraw(value)
    self.value -= value
  end
end

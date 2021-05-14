class TrustFund < ApplicationRecord
  belongs_to :user
  validates :name, presence: true
  validates :fund_type, presence: true
  has_many :accounts, through: :investments
  enum fund_type: [:STOCK, :FUND, :DIRECT_TREASURY]

  def totalInvestments
    investments = Investment.where(trust_fund_id: self.id)
    totalInvestments = 0
    investments.each do |inv|
      totalInvestments = inv.value + totalInvestments
    end
    return totalInvestments
  end
end

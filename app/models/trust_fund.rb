class TrustFund < ApplicationRecord
  belongs_to :user
  validates :name, presence: true
  validates :fund_type, presence: true
  has_many :users, through: :investments
  enum fund_type: [:STOCK, :FUND, :DIRECT_TREASURY]
end

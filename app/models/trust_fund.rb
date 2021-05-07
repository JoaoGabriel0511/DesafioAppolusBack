class TrustFund < ApplicationRecord
  belongs_to :user
  validates :name, presence: true
  validates :fund_type, presence: true
  enum fund_type: [:STOCK, :FUND, :DIRECT_TREASURY]
end

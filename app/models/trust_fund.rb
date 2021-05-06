class TrustFund < ApplicationRecord
  belongs_to :user
  validate :name, presence: true
  validate :fund_type, presence: true
end

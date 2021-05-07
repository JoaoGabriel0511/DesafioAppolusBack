class Investment < ApplicationRecord
  belongs_to :user
  belongs_to :trust_fund
  validates :user_id, uniqueness: { scope: :trust_fund_id }
end

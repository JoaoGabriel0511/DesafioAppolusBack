class Investment < ApplicationRecord
  belongs_to :user
  belongs_to :trust_fund
end

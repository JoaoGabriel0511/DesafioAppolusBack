class AddTrustFundReferenceToTrasaction < ActiveRecord::Migration[6.1]
  def change
    add_reference :transactions, :trust_fund, index: true
  end
end

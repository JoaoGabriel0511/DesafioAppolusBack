class AddAccountReferenceToInvestment < ActiveRecord::Migration[6.1]
  def change
    add_reference :investments, :account, index: true
  end
end

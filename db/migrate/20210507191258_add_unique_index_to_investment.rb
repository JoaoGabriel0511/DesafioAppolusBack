class AddUniqueIndexToInvestment < ActiveRecord::Migration[6.1]
  def change
    add_index :investments, [:user_id, :trust_fund_id], unique: true
  end
end

class RrmoveUserFkFRomInvestment < ActiveRecord::Migration[6.1]
  def change
    remove_column :investments, :account_id
  end
end

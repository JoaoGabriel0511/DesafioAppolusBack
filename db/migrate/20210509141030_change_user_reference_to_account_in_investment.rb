class ChangeUserReferenceToAccountInInvestment < ActiveRecord::Migration[6.1]
  def change
    rename_column :investments, :user_id, :account_id
  end
end

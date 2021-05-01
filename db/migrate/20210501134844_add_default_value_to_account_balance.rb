class AddDefaultValueToAccountBalance < ActiveRecord::Migration[6.1]
  def change
    change_column_default :accounts, :balance, 0
  end
end

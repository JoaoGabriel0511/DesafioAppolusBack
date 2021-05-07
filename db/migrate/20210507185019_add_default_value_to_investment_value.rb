class AddDefaultValueToInvestmentValue < ActiveRecord::Migration[6.1]
  def change
    change_column_default :investments, :value, 0
  end
end

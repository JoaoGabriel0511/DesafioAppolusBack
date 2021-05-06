class TrustFundModelAjustments < ActiveRecord::Migration[6.1]
  def change
    rename_column :trust_funds, :type, :fund_type
    change_column_default :trust_funds, :fund_value, 0
  end
end

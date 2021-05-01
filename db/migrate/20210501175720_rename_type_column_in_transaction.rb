class RenameTypeColumnInTransaction < ActiveRecord::Migration[6.1]
  def change
    rename_column :transactions, :type, :transaction_type
  end
end

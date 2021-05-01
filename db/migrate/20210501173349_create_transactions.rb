class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.references :account, null: false, foreign_key: true
      t.float :value
      t.float :balance
      t.integer :type

      t.timestamps
    end
  end
end

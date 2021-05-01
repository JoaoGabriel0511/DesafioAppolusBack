class MakeUserKeyBeUniqueInAccount < ActiveRecord::Migration[6.1]
  def change
    change_column :accounts, :balance, :float, unique: false
    change_column :accounts, :user_id, :integer, unique: true
  end
end

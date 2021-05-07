class CreateInvestments < ActiveRecord::Migration[6.1]
  def change
    create_table :investments do |t|
      t.float :value
      t.references :user, null: false, foreign_key: true
      t.references :trust_fund, null: false, foreign_key: true

      t.timestamps
    end
  end
end

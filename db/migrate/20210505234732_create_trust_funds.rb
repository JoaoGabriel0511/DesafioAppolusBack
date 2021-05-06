class CreateTrustFunds < ActiveRecord::Migration[6.1]
  def change
    create_table :trust_funds do |t|
      t.string :name
      t.integer :type
      t.references :user, null: false, foreign_key: true
      t.float :fund_value

      t.timestamps
    end
  end
end

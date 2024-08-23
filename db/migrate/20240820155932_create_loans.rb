class CreateLoans < ActiveRecord::Migration[7.0]
  def change
    create_table :loans do |t|
      t.string :status, default: "requested"
      t.decimal :amount
      t.float :interest_rate, default: 0
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

class AddParentIdToLoans < ActiveRecord::Migration[7.0]
  def change
    add_column :loans, :parent_id, :integer
  end
end

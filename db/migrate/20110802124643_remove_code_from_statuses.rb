class RemoveCodeFromStatuses < ActiveRecord::Migration
  def up
    remove_column :statuses, :code
  end

  def down
    add_column :statuses, :code, :string
  end
end

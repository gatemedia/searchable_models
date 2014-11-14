class AddGroupIdToCars < ActiveRecord::Migration
  def change
    add_column :cars, :group_id, :integer
  end
end

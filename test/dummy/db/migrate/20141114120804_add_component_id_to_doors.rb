class AddComponentIdToDoors < ActiveRecord::Migration
  def change
    add_column :doors, :component_id, :integer
  end
end

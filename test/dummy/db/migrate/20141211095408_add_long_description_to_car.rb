class AddLongDescriptionToCar < ActiveRecord::Migration
  def change
    add_column :cars, :long_description, :text
  end
end

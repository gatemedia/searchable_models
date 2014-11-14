class CreateDoors < ActiveRecord::Migration
  def change
    create_table :doors do |t|
      t.string :name
      t.references :car, index: true

      t.timestamps
    end
  end
end

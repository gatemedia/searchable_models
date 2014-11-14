class CreateCars < ActiveRecord::Migration
  def change
    create_table :cars do |t|
      t.string :name
      t.string :description
      t.integer :number_of_doors
      t.string :brand
      t.string :model
      t.date :import_date
      t.integer :kind

      t.timestamps
    end
  end
end

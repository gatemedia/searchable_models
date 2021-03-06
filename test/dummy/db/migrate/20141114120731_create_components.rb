class CreateComponents < ActiveRecord::Migration
  def change
    create_table :components do |t|
      t.string :name
      t.string :serial
      t.references :provider, index: true

      t.timestamps
    end
  end
end

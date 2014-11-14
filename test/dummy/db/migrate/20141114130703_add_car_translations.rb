class AddCarTranslations < ActiveRecord::Migration
  def up
    Car.create_translation_table! :commercial_name => :string
  end

  def down
    Car.drop_translation_table!
  end
end

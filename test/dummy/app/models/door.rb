class Door < ActiveRecord::Base
  belongs_to :car
  belongs_to :component
end

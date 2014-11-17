class Car < ActiveRecord::Base
  # fuzzy search on one field
  search_on :brand, :mode => :fuzzy

  # fuzzy search on one field with named parameter
  search_on :model, :mode => :fuzzy, :param => :m

  # fuzzy search on multiple fields with named parameter
  search_on :name, :mode => :fuzzy, :param => :query
  search_on :description, :mode => :fuzzy, :param => :query

  # exact search on one field
  search_on :number_of_doors

  # search on belong_to ids
  belongs_to :group
  search_on :group_id

  # search with through
  has_many :doors
  search_on :component_id, :through => :doors

  # search with deep through
  search_on :provider_id, :through => { :doors => :component }

  # search with scope
  scope :imported_on, ->(date) { where(:import_date => date) }
  search_on :import_date, :mode => :scope, :scope => :imported_on

  # search on enums
  enum :kind => [:van, :sedan, :family]
  search_on :kind, :mode => :enum, :param => :type_of_car

  # search on tags (support for acts-as-taggable-on)
  acts_as_taggable
  search_on :tags

  # search on i18n fields (support for globalize)
  translates :commercial_name
  search_on :commercial_name, :mode => :fuzzy
end

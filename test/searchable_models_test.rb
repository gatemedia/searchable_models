require "test_helper"

class SearchableModelsTest < ActiveSupport::TestCase
  test "module is correctly included" do
    assert ActiveRecord::Base.ancestors.include?(SearchableModels::Searchable)
  end
end

require "test_helper"

class CarTest < ActiveSupport::TestCase
  test "search car with fuzzy search on one field" do
    assert_results(Car.search(:brand => "foo"))
  end

  test "search car with fuzzy search on one field with named param" do
    assert_results(Car.search(:m => "foo"))
  end

  test "search car with fuzzy search on multiple fields" do
    assert_results(Car.search(:query => "foo"))
  end

  test "search car with exact search" do
    assert_results(Car.search(:number_of_doors => 2))
  end

  test "search car with belong_to id" do
    assert_results(Car.search(:group_id => groups(:group_foo).id))
  end

  test "search car with through" do
    assert_results(Car.search(:component_id => components(:component_foo)))
  end

  test "search car with deep through" do
    assert_results(Car.search(:provider_id => providers(:provider_foo)))
  end

  test "search car with scope" do
    assert_results(Car.search(:import_date => "1990-10-20"))
  end

  test "search car with enum" do
    assert_results(Car.search(:type_of_car => "family"))
  end
end

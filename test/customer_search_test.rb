require 'minitest/autorun'
require './lib/customer_search'

class CustomerSearchTest < Minitest::Test
  def setup
    @file_path = 'test/data/customers.json'
    @dublin_location = { lat: 53.3381985, lon: -6.2592576 }
    @tokyo_location = { lat: 35.6833, lon: 139.6833 }
  end

  def test_zero_matching_customers
    assert_equal [], CustomerSearch.sorted_customers_from_file_near_origin(@file_path, @dublin_location[:lat], @dublin_location[:lon], 10, 'user_id')
  end

  def test_matching_customers_are_returned_and_sorted_by_attribute
    worldwide_customers = CustomerSearch.sorted_customers_from_file_near_origin(@file_path, @dublin_location[:lat], @dublin_location[:lon], 100_000, 'user_id')
    all_customers = [{ 'user_id' => 1, 'name' => 'Alice Cahill' }, { 'user_id' => 2, 'name' => 'Ian McArdle' }, { 'user_id' => 3, 'name' => 'Jack Enright' }, { 'user_id' => 4, 'name' => 'Ian Kehoe' }, { 'user_id' => 5, 'name' => 'Nora Dempsey' }, { 'user_id' => 6, 'name' => 'Theresa Enright' }, { 'user_id' => 7, 'name' => 'Frank Kehoe' }, { 'user_id' => 8, 'name' => 'Eoin Ahearn' }, { 'user_id' => 9, 'name' => 'Jack Dempsey' }, { 'user_id' => 10, 'name' => 'Georgina Gallagher' }, { 'user_id' => 11, 'name' => 'Richard Finnegan' }, { 'user_id' => 12, 'name' => 'Christina McArdle' }, { 'user_id' => 13, 'name' => 'Olive Ahearn' }, { 'user_id' => 14, 'name' => 'Helen Cahill' }, { 'user_id' => 15, 'name' => 'Michael Ahearn' }, { 'user_id' => 16, 'name' => 'Ian Larkin' }, { 'user_id' => 17, 'name' => 'Patricia Cahill' }, { 'user_id' => 18, 'name' => 'Bob Larkin' }, { 'user_id' => 19, 'name' => 'Enid Cahill' }, { 'user_id' => 20, 'name' => 'Enid Enright' }, { 'user_id' => 21, 'name' => 'David Ahearn' }, { 'user_id' => 22, 'name' => 'Charlie McArdle' }, { 'user_id' => 23, 'name' => 'Eoin Gallagher' }, { 'user_id' => 24, 'name' => 'Rose Enright' }, { 'user_id' => 25, 'name' => 'David Behan' }, { 'user_id' => 26, 'name' => 'Stephen McArdle' }, { 'user_id' => 27, 'name' => 'Enid Gallagher' }, { 'user_id' => 28, 'name' => 'Charlie Halligan' }, { 'user_id' => 29, 'name' => 'Oliver Ahearn' }, { 'user_id' => 30, 'name' => 'Nick Enright' }, { 'user_id' => 31, 'name' => 'Alan Behan' }, { 'user_id' => 39, 'name' => 'Lisa Ahearn' }]
    assert_equal all_customers.size, worldwide_customers.size
    assert_equal all_customers, worldwide_customers

    nearby_customers = CustomerSearch.sorted_customers_from_file_near_origin(@file_path, @dublin_location[:lat], @dublin_location[:lon], 50, 'name')
    customers = [{ 'user_id' => 31, 'name' => 'Alan Behan' }, { 'user_id' => 12, 'name' => 'Christina McArdle' }, { 'user_id' => 4, 'name' => 'Ian Kehoe' }, { 'user_id' => 39, 'name' => 'Lisa Ahearn' }, { 'user_id' => 15, 'name' => 'Michael Ahearn' }, { 'user_id' => 5, 'name' => 'Nora Dempsey' }, { 'user_id' => 11, 'name' => 'Richard Finnegan' }, { 'user_id' => 6, 'name' => 'Theresa Enright' }]
    assert_equal nearby_customers.size, customers.size
    assert_equal nearby_customers, customers
  end

  def test_only_name_and_user_id_are_returned_per_customers
    worldwide_customers = CustomerSearch.sorted_customers_from_file_near_origin(@file_path, @tokyo_location[:lat], @tokyo_location[:lon], 100_000, 'user_id')
    assert worldwide_customers.all? { |c| c.keys.all? { |k| CustomerParser::DESIRED_OUTPUT_CUSTOMER_ATTRS.include?(k) } }
  end
end

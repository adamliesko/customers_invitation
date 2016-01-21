require 'minitest/autorun'
require './lib/customer_parser'

class CustomerParserTest < Minitest::Test
  def test_raises_error_on_invalid_line
    assert_raises CustomerParser::InvalidCustomerRecord do
      CustomerParser.load_customers_with_location_from_file('test/data/faulty.json')
    end
  end

  def test_parses_customer_and_their_location_from_file
    file_path = 'test/data/customers.json'
    customers = CustomerParser.load_customers_with_location_from_file(file_path)
    assert customers.all? { |c, loc| CustomerParser::DESIRED_OUTPUT_CUSTOMER_ATTRS && c.keys && c.is_a?(Hash) && loc.is_a?(Geokit::LatLng) }
    assert_equal customers.size, File.open(file_path).readlines.count
  end
end

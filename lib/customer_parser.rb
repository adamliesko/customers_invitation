require 'json'
require 'geokit'

module CustomerParser
  DESIRED_OUTPUT_CUSTOMER_ATTRS = %w(user_id name)
  CUSTOMER_ATTRS = DESIRED_OUTPUT_CUSTOMER_ATTRS + %w(longitude latitude)

  class InvalidCustomerRecord < StandardError
  end

  def self.load_customers_with_location_from_file(file_path)
    File.open(file_path).collect do |line|
      parse_customer_record_with_location(line)
    end
  end

  class << self
    def parse_customer_record_with_location(json_string)
      customer = JSON.parse(json_string)
      fail CustomerParser::InvalidCustomerRecord, "Required customer attributes: #{CUSTOMER_ATTRS} missing in #{customer}" unless verify_customer_attrs(customer)
      customer_location = Geokit::LatLng.new(customer['latitude'], customer['longitude'])
      [clean_customer_record(customer), customer_location]
    end

    def verify_customer_attrs(customer)
      CustomerParser::CUSTOMER_ATTRS.all? { |attr| customer[attr] }
    end

    def clean_customer_record(customer)
      customer.keep_if { |k| CustomerParser::DESIRED_OUTPUT_CUSTOMER_ATTRS.include?(k) }
    end
  end
end

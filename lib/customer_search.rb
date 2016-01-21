require 'json'
require 'geokit'

module CustomerSearch
  Geokit.default_units = :kms
  Geokit.default_formula = :sphere

  DESIRED_OUTPUT_CUSTOM_ATTRS = %w(user_id name)

  def self.sorted_customers_from_file_near_origin(file_path, origin_lat, origin_lon, distance_km, sort_attr)
    matching_customers = []
    origin = Geokit::LatLng.new(origin_lat, origin_lon)

    File.open(file_path).each do |line|
      customer, customer_loc = parse_customer_record_with_location(line)
      matching_customers << customer if origin.distance_to(customer_loc) < distance_km
    end

    sort_customers_by_attr(matching_customers, sort_attr)
  end

  class << self
    private

    def sort_customers_by_attr(customers, attr)
      customers.sort_by { |c| c[attr] }
    end

    def parse_customer_record_with_location(json_string)
      customer = JSON.parse(json_string)
      customer_location = Geokit::LatLng.new(customer['latitude'], customer['longitude'])
      [clean_customer_record(customer), customer_location]
    end

    def clean_customer_record(customer)
      customer.keep_if { |k| DESIRED_OUTPUT_CUSTOM_ATTRS.include?(k) }
    end
  end
end

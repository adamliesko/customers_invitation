require 'json'
require 'geokit'
require 'customer_parser'

module CustomerSearch
  Geokit.default_units = :kms
  Geokit.default_formula = :sphere

  def self.sorted_customers_from_file_near_origin(file_path, origin_lat, origin_lon, distance_km, sort_attr)
    origin = Geokit::LatLng.new(origin_lat, origin_lon)

    customers = CustomerParser.load_customers_with_location_from_file(file_path)
    matching_customers = customers.select { |_c, c_location| origin.distance_to(c_location) < distance_km }.map { |c, _c_loc| c }
    sort_customers_by_attr(matching_customers, sort_attr)
  end

  class << self
    private

    def sort_customers_by_attr(customers, attr)
      customers.sort_by { |c| c[attr] }
    end
  end
end

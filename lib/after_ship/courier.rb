class AfterShip
  # Wrapper object for AfterShip courier:
  # https://www.aftership.com/docs/api/4/couriers/get-couriers
  class Courier
    include Attributes

    # Unique code of courier.
    #
    # @return [String]
    attr_accessor :slug

    # Name of courier.
    #
    # @return [String]
    attr_accessor :name

    # Contact phone number of courier.
    #
    # @return [String]
    attr_accessor :phone

    # Other name of courier.
    #
    # @return [String]
    attr_accessor :other_name

    # Website link of courier.
    #
    # @return [String]
    attr_accessor :web_url

    # The extra fields need for tracking, such as `tracking_account_number`,
    # `tracking_postal_code`, `tracking_ship_date`.
    #
    # @return [Array]
    attr_accessor :required_fields

    # Better interface for a courier.
    #
    # @param data [Hash] tracking hash
    def initialize(data)
      load_attributes(data)
    end
  end
end

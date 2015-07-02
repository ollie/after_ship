# Gems.
require 'typhoeus'
require 'multi_json'

# Core classes.
require 'after_ship/core/version'
require 'after_ship/core/attributes'
require 'after_ship/core/date_utils'
require 'after_ship/core/request'
require 'after_ship/core/error'
require 'after_ship/core/error_handler'

# AfterShip classes.
require 'after_ship/tracking'
require 'after_ship/checkpoint'
require 'after_ship/courier'

# Quick rundown, check individual methods for more info:
#
#   client = AfterShip.new(api_key: 'your-aftership-api-key')
#   client.trackings
#   client.tracking('tracking-number', 'ups')
#   client.create_tracking('tracking-number', 'ups', order_id: 'external-id')
#   client.update_tracking('tracking-number', 'ups', order_id: 'external-id')
#   client.couriers
#
# To debug:
#
#   AfterShip.debug = true
#
# Some test trackings:
#
#   client.tracking('1ZA2207X0444990982', 'ups')
class AfterShip
  # The API root URL.
  DEFAULT_API_ADDRESS = 'https://api.aftership.com/v4'

  # The trackings endpoint URL.
  TRACKINGS_ENDPOINT = "#{DEFAULT_API_ADDRESS}/trackings"

  # The activated couriers endpoint URL.
  COURIERS_ENDPOINT = "#{DEFAULT_API_ADDRESS}/couriers"

  # Common JSON loading/dumping options.
  JSON_OPTIONS = {
    symbolize_keys: true # Symbol keys to string keys
  }

  # Tag to human-friendly status conversion
  TAG_STATUS = {
    'Pending'        => 'Pending',
    'InfoReceived'   => 'Info Received',
    'InTransit'      => 'In Transit',
    'OutForDelivery' => 'Out for Delivery',
    'AttemptFail'    => 'Attempt Failed',
    'Delivered'      => 'Delivered',
    'Exception'      => 'Exception',
    'Expired'        => 'Expired'
  }

  class << self
    # If debugging is turned on, it is passed to Typhoeus as "verbose" options,
    # which is passed down to Ethon and displays request/response in STDERR.
    #
    # @return [Bool]
    attr_accessor :debug
  end

  # The API key required for the AfterShip service.
  #
  # @return [String]
  attr_reader :api_key

  # Init the client:
  #
  #   client = AfterShip.new(api_key: 'your-aftership-api-key')
  #
  # @param  options          [Hash]
  # @option options :api_key [String]
  def initialize(options)
    @api_key = options.fetch(:api_key)
  end

  # Get a list of trackings.
  # https://www.aftership.com/docs/api/4/trackings/get-trackings
  #
  #   client.trackings
  #
  #   # Will return list of Tracking objects:
  #
  #   [
  #     #<AfterShip::Tracking ...>,
  #     #<AfterShip::Tracking ...>,
  #     ...
  #   ]
  #
  # @return [Hash]
  def trackings
    data = Request.get(url: TRACKINGS_ENDPOINT, api_key: api_key) do |response|
      response.fetch(:data).fetch(:trackings)
    end

    data.map { |datum| Tracking.new(datum) }
  end

  # Get a single tracking. Raises an error if not found.
  # https://www.aftership.com/docs/api/4/trackings/get-trackings-slug-tracking_number
  #
  #   client.tracking('tracking-number', 'ups')
  #
  #   # Will return Tracking object or raise AfterShip::Error::NotFound:
  #
  #   #<AfterShip::Tracking:0x007f838ef44e58
  #     @active=false,
  #     @android=[],
  #     @courier="UPS",
  #     @created_at=#<DateTime: 2014-11-19T15:16:17+00:00 ...>,
  #     @custom_fields={},
  #     @customer_name=nil,
  #     @delivery_time=8,
  #     @destination_country_iso3="USA",
  #     @emails=[],
  #     @expected_delivery=nil,
  #     @id="546cb4414a1a2097122ae7b1",
  #     @ios=[],
  #     @order_id="PL-66448782",
  #     @order_id_path=nil,
  #     @origin_country_iso3="IND",
  #     @shipment_package_count=1,
  #     @shipment_type="UPS SAVER",
  #     @shipment_weight=0.5,
  #     @shipment_weight_unit="kg",
  #     @signed_by="MET CUSTOM",
  #     @slug="ups",
  #     @smses=[],
  #     @source="api",
  #     @status="Delivered",
  #     @tag="Delivered",
  #     @title="1ZA2207X0490715335",
  #     @tracked_count=6,
  #     @tracking_account_number=nil,
  #     @tracking_number="1ZA2207X0490715335",
  #     @tracking_postal_code=nil,
  #     @tracking_ship_date=nil,
  #     @unique_token="-y6ziF438",
  #     @updated_at=#<DateTime: 2014-11-19T22:12:32+00:00 ...>,
  #     @checkpoints=[
  #       #<AfterShip::Checkpoint:0x007f838ef57d50
  #         @checkpoint_time=
  #         #<DateTime: 2014-11-11T19:12:00+00:00 ...>,
  #         @city="MUMBAI",
  #         @country_iso3=nil,
  #         @country_name="IN",
  #         @courier="UPS",
  #         @created_at=
  #         #<DateTime: 2014-11-19T15:16:17+00:00 ...>,
  #         @message="PICKUP SCAN",
  #         @slug="ups",
  #         @state=nil,
  #         @status="In Transit",
  #         @tag="InTransit",
  #         @zip=nil>,
  #       #<AfterShip::Checkpoint ...>,
  #       ...
  #     ]
  #   >
  #
  # @param tracking_number [String]
  # @param courier [String]
  #
  # @return [Hash]
  def tracking(tracking_number, courier)
    url  = "#{TRACKINGS_ENDPOINT}/#{courier}/#{tracking_number}"
    data = Request.get(url: url, api_key: api_key) do |response|
      response.fetch(:data).fetch(:tracking)
    end

    Tracking.new(data)
  end

  # Create a new tracking.
  # https://www.aftership.com/docs/api/4/trackings/post-trackings
  #
  #   client.create_tracking('tracking-number', 'ups', order_id: 'external-id')
  #
  #   # Will return Tracking object or raise
  #   # AfterShip::Error::TrackingAlreadyExists:
  #
  #   #<AfterShip::Tracking ...>
  #
  # @param tracking_number [String]
  # @param courier [String]
  # @param options [Hash]
  #
  # @return [Hash]
  #
  # rubocop:disable Metrics/MethodLength
  def create_tracking(tracking_number, courier, options = {})
    body = {
      tracking: {
        tracking_number: tracking_number,
        slug:            courier
      }.merge(options)
    }

    data = Request.post(url: TRACKINGS_ENDPOINT, api_key: api_key,
                        body: body) do |response|
      response.fetch(:data).fetch(:tracking)
    end

    Tracking.new(data)
  end

  # Update a tracking.
  # https://www.aftership.com/docs/api/4/trackings/put-trackings-slug-tracking_number
  #
  #   client.update_tracking('tracking-number', 'ups', order_id: 'external-id')
  #
  #   # Will return Tracking object or raise
  #   # AfterShip::Error::TrackingAlreadyExists:
  #
  #   #<AfterShip::Tracking ...>
  #
  # @param tracking_number [String]
  # @param courier [String]
  # @param options [Hash]
  #
  # @return [Hash]
  def update_tracking(tracking_number, courier, options = {})
    url  = "#{TRACKINGS_ENDPOINT}/#{courier}/#{tracking_number}"
    body = {
      tracking: options
    }

    data = Request.put(url: url, api_key: api_key, body: body) do |response|
      response.fetch(:data).fetch(:tracking)
    end

    Tracking.new(data)
  end

  # Get a list of activated couriers.
  # https://www.aftership.com/docs/api/4/couriers/get-couriers
  #
  #   client.couriers
  #
  #   # Will return list of Courier objects:
  #
  #   [
  #     #<AfterShip::Courier:0x007fa2771d4bf8
  #       @name="USPS",
  #       @other_name="United States Postal Service",
  #       @phone="+1 800-275-8777",
  #       @required_fields=[],
  #       @slug="usps",
  #       @web_url="https://www.usps.com">,
  #     #<AfterShip::Courier ...>
  #     ...
  #   ]
  #
  # @return [Hash]
  def couriers
    data = Request.get(url: COURIERS_ENDPOINT, api_key: api_key) do |response|
      response.fetch(:data).fetch(:couriers)
    end

    data.map { |datum| Courier.new(datum) }
  end
end

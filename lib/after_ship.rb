require 'typhoeus'
require 'multi_json'

require 'attributes'
require 'date_utils'
require 'after_ship/version'
require 'after_ship/tracking'
require 'after_ship/checkpoint'

# Init the client:
#
#   client = AfterShip.new(api_key: 'your-aftership-api-key')
#
# Get a list of trackings
# https://www.aftership.com/docs/api/3.0/tracking/get-trackings
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
# Get a tracking
# https://www.aftership.com/docs/api/3.0/tracking/get-trackings-slug-tracking_number
#
#   client.tracking('tracking-number', 'ups')
#
#   # Will return Tracking object or raise AfterShip::ResourceNotFoundError
#   # if not exists:
#
#   #<AfterShip::Tracking:0x007fe555bd9560
#     @active=false,
#     @courier="UPS",
#     @created_at=#<DateTime: 2014-05-08T15:25:01+00:00 ...>,
#     @updated_at=#<DateTime: 2014-07-18T09:00:47+00:00 ...>>
#     @custom_fields={},
#     @customer_name=nil,
#     @destination_country_iso3="USA",
#     @emails=[],
#     @expected_delivery=nil,
#     @order_id="PL-12480166",
#     @order_id_path=nil,
#     @origin_country_iso3="IND",
#     @shipment_package_count=0,
#     @shipment_type="EXPEDITED",
#     @signed_by="FRONT DOOR",
#     @slug="ups",
#     @smses=[],
#     @source="api",
#     @status="Delivered",
#     @tag="Delivered",
#     @title="1ZA2207X6790326683",
#     @tracked_count=47,
#     @tracking_number="1ZA2207X6790326683",
#     @unique_token="ly9ueXUJC",
#     @checkpoints=[
#       #<AfterShip::Checkpoint:0x007fe555bb0340
#         @checkpoint_time=#<DateTime: 2014-05-12T14:07:00+00:00 ...>,
#         @city="NEW YORK",
#         @country_iso3=nil,
#         @country_name="US",
#         @courier="UPS",
#         @created_at=#<DateTime: 2014-05-12T18:34:32+00:00 ...>,
#         @message="DELIVERED",
#         @slug="ups",
#         @state="NY",
#         @status="Delivered",
#         @tag="Delivered",
#         @zip="10075">
#       #<AfterShip::Checkpoint ...>,
#       ...
#     ]>
#
# Create a new tracking
# https://www.aftership.com/docs/api/3.0/tracking/post-trackings
#
#   client.create_tracking('tracking-number', 'ups', order_id: 'external-id')
#
#   # Will return Tracking object or raise AfterShip::InvalidArgumentError
#   # if it exists:
#
#   #<AfterShip::Tracking ...>
#
# Update a tracking
# https://www.aftership.com/docs/api/3.0/tracking/put-trackings-slug-tracking_number
#
#   client.update_tracking('tracking-number', 'ups', order_id: 'external-id')
#
# To debug:
#
#   AfterShip.debug = true
#
# client.tracking('9405903699300211343566', 'usps') # In transit
# client.tracking('1ZA2207X6794165804', 'ups')      # Delivered, wild
# client.tracking('1ZA2207X6791425225', 'ups')      # Delivered, ok
# client.tracking('1ZA2207X6790326683', 'ups')      # Delivered, ok
class AfterShip
  class Error                   < StandardError; end
  class InvalidJSONDataError    < Error; end # 400
  class InvalidCredentialsError < Error; end # 401
  class RequestFailedError      < Error; end # 402
  class ResourceNotFoundError   < Error; end # 404
  class InvalidArgumentError    < Error; end # 409
  class TooManyRequestsError    < Error; end # 429
  class ServerError             < Error; end # 500, 502, 503, 504
  class UnknownError            < Error; end

  DEFAULT_API_ADDRESS = 'https://api.aftership.com/v3'
  TRACKINGS_ENDPOINT  = "#{ DEFAULT_API_ADDRESS }/trackings"

  JSON_OPTIONS        = {
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

  attr_reader :api_key

  # @param options [Hash]
  #   api_key [String]
  def initialize(options)
    require_arguments(
      api_key: options[:api_key]
    )

    @api_key = options.delete(:api_key)
  end

  # Get a list of trackings.
  # https://www.aftership.com/docs/api/3.0/tracking/get-trackings
  #
  # @return [Hash]
  def trackings
    response = request_response(TRACKINGS_ENDPOINT, {}, :get)
    data     = response.fetch(:data).fetch(:trackings)

    data.map { |datum| Tracking.new(datum) }
  end

  # Get a single tracking. Raises an error if not found.
  # https://www.aftership.com/docs/api/3.0/tracking/get-trackings-slug-tracking_number
  #
  # @param tracking_number [String]
  # @param courier [String]
  #
  # @return [Hash]
  def tracking(tracking_number, courier)
    require_arguments(tracking_number: tracking_number, courier: courier)

    url = "#{ TRACKINGS_ENDPOINT }/#{ courier }/#{ tracking_number }"

    response = request_response(url, {}, :get)
    data     = response.fetch(:data).fetch(:tracking)

    Tracking.new(data)
  end

  # Create a new tracking.
  # https://www.aftership.com/docs/api/3.0/tracking/post-trackings
  #
  # @param tracking_number [String]
  # @param courier [String]
  # @param options [Hash]
  #
  # @return [Hash]
  def create_tracking(tracking_number, courier, options = {})
    require_arguments(tracking_number: tracking_number, courier: courier)

    params = {
      tracking: {
        tracking_number: tracking_number,
        slug:            courier
      }.merge(options)
    }

    response = request_response(TRACKINGS_ENDPOINT, params, :post)
    data     = response.fetch(:data).fetch(:tracking)

    Tracking.new(data)
  end

  # https://www.aftership.com/docs/api/3.0/tracking/put-trackings-slug-tracking_number
  #
  # @param tracking_number [String]
  # @param courier [String]
  # @param options [Hash]
  #
  # @return [Hash]
  def update_tracking(tracking_number, courier, options = {})
    require_arguments(tracking_number: tracking_number, courier: courier)

    url = "#{ TRACKINGS_ENDPOINT }/#{ courier }/#{ tracking_number }"
    params = {
      tracking: options
    }

    response = request_response(url, params, :put)
    data     = response.fetch(:data).fetch(:tracking)

    Tracking.new(data)
  end

  # Raises an ArgumentError if any of the args is empty or nil.
  #
  # @param hash [Hash] arguments needed in options
  def require_arguments(hash)
    hash.each do |name, value|
      if value.respond_to?(:empty?)
        invalid_argument!(name) if value.empty?
      else
        invalid_argument!(name)
      end
    end
  end

  protected

  # @param name [Symbol]
  def invalid_argument!(name)
    fail ArgumentError, "Argument #{ name } cannot be empty"
  end

  # Prepare a `Typhoeus::Request`, send it over the net and deal
  # with te response by either returning a Hash or raising an error.
  #
  # @param url [String]
  # @param body_hash [Hash]
  # @param method [Symbol]
  #
  # @return [Hash]
  def request_response(url, body_hash, method = :get)
    body_json = MultiJson.dump(body_hash)

    request = Typhoeus::Request.new(
      url,
      method:  method,
      verbose: self.class.debug,
      body:    body_json,
      headers: {
        'aftership-api-key' => @api_key,
        'Content-Type'      => 'application/json'
      }
    )

    if self.class.debug
      request.on_complete do |response|
        puts
        puts 'Request body:'
        puts request.options[:body]
        puts
        puts 'Response body:'
        puts response.body
        puts
      end
    end

    response = request.run
    response_to_json(response)
  end

  # Deal with API response, either return a Hash or raise an error.
  #
  # @param response [Typhoeus::Response]
  #
  # @return [Hash]
  #
  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/MethodLength
  def response_to_json(response)
    json_response = parse_response(response)

    case json_response[:meta][:code]
    when 200, 201
      return json_response
    when 400
      fail InvalidJSONDataError, json_response[:meta][:error_message]
    when 401
      fail InvalidCredentialsError, json_response[:meta][:error_message]
    when 402
      fail RequestFailedError, json_response[:meta][:error_message]
    when 404
      fail ResourceNotFoundError, json_response[:meta][:error_message]
    when 409
      fail InvalidArgumentError, json_response[:meta][:error_message]
    when 429
      fail TooManyRequestsError, json_response[:meta][:error_message]
    when 500, 502, 503, 504
      fail ServerError, json_response[:meta][:error_message]
    else
      fail UnknownError, json_response[:meta][:error_message]
    end
  end

  # Parse response body into a Hash.
  #
  # @param response [Typhoeus::Response]
  #
  # @return [Hash]
  def parse_response(response)
    MultiJson.load(response.body, JSON_OPTIONS)
  end
end

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
#   # Will return JSON:
#
#   {
#     ...,
#     data: {
#       ...
#       trackings: [
#         {
#           ...
#         },
#         ...
#       ]
#     }
#   }
#
# Get a tracking
# https://www.aftership.com/docs/api/3.0/tracking/get-trackings-slug-tracking_number
#
#   client.tracking('tracking-number', 'ups')
#
#   # Will return JSON or raise AfterShip::ResourceNotFoundError if not exists:
#
#   {
#     ...,
#     data: {
#       tracking: {
#         ...
#       }
#     }
#   }
#
# Create a new tracking
# https://www.aftership.com/docs/api/3.0/tracking/post-trackings
#
#   client.create_tracking('tracking-number', 'ups', order_id: 'external-id')
#
#   # Will return JSON or raise AfterShip::InvalidArgumentError if it exists:
#
#   {
#     ...,
#     data: {
#       tracking: {
#         ...
#       }
#     }
#   }
#
# Update a tracking
# https://www.aftership.com/docs/api/3.0/tracking/put-trackings-slug-tracking_number
#
#   client.update_tracking('tracking-number', 'ups', order_id: 'external-id')
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
    request_response(TRACKINGS_ENDPOINT, {}, :get)
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
    Tracking.new(response[:data])
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

    request_response(TRACKINGS_ENDPOINT, params, :post)
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

    request_response(url, params, :put)
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
      method: method,
      body:   body_json,
      headers: {
        'aftership-api-key' => @api_key,
        'Content-Type'      => 'application/json'
      }
    )

    response = request.run
    response_to_json(response)
  end

  # Deal with API response, either return a Hash or raise an error.
  #
  # @param response [Typhoeus::Response]
  #
  # @return [Hash]
  #
  # rubocop:disable Style/CyclomaticComplexity, Style/MethodLength
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

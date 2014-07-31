class AfterShip
  # Wrapper object for AfterShip tracking:
  # https://www.aftership.com/docs/api/3.0/tracking/get-trackings-slug-tracking_number
  class Tracking
    include Attributes

    # Date and time of the tracking created.
    #
    # @return [DateTime]
    attr_reader :created_at

    # Date and time of the tracking last updated.
    #
    # @return [DateTime]
    attr_reader :updated_at

    # Tracking number, e.g. +1ZA2207X6794165804+.
    #
    # @return [String]
    attr_accessor :tracking_number

    # Unique code of courier.
    #
    # @return [String]
    attr_reader :slug

    # Courier name
    #
    # @return [String]
    attr_accessor :courier

    # Whether or not AfterShip will continue tracking the shipments. Value is
    # +false+ when status is +Delivered+ or +Expired+.
    #
    # @return [Boolean]
    attr_accessor :active

    # Custom fields of the tracking.
    #
    # @return [Hash]
    attr_accessor :custom_fields

    # Customer name of the tracking.
    #
    # @return [String]
    attr_accessor :customer_name

    # Destination country of the tracking. ISO Alpha-3 (three letters). If you
    # use postal service to send international shipments, AfterShip will
    # automatically get tracking results from destination postal service based
    # on destination country.
    #
    # @return [String]
    attr_accessor :destination_country_iso3

    # Email address(es) to receive email notifications. Comma separated for
    # multiple values.
    #
    # @return [Array<String>]
    attr_accessor :emails

    # Expected delivery date (if any).
    #
    # Empty String,
    # YYYY-MM-DD,
    # YYYY-MM-DDTHH:MM:SS, or
    # YYYY-MM-DDTHH:MM:SS+TIMEZONE.
    #
    # @return [DateTime]
    attr_reader :expected_delivery

    # Text field for order ID.
    #
    # @return [String]
    attr_accessor :order_id

    # Text field for order path.
    #
    # @return [String]
    attr_accessor :order_id_path

    # Origin country of the tracking. ISO Alpha-3 (three letters).
    #
    # @return [String]
    attr_accessor :origin_country_iso3

    # You can use the value, to direct access the tracking result at this url:
    # https://yourusername.aftership.com/unique_token
    #
    # @return [String]
    attr_accessor :unique_token

    # Number of packages under the tracking.
    #
    # @return [Number]
    attr_accessor :shipment_package_count

    # Shipment type provided by carrier (if any).
    #
    # @return [String]
    attr_accessor :shipment_type

    # Signed by information for delivered shipment (if any).
    #
    # @return [String]
    attr_accessor :signed_by

    # Phone number(s) to receive sms notifications. The phone number(s) to
    # receive sms notifications. Phone number should begin with <code>+</code>
    # and +Area Code+ before phone number. Comma separated for multiple values.
    #
    # @return [Array<String>]
    attr_accessor :smses

    # Source of how this tracking is added.
    #
    # @return [String]
    attr_accessor :source

    # Current status of tracking.
    #
    # Value: +Pending+, +InfoReceived+, +InTransit+, +OutForDelivery+,
    # +AttemptFail+, +Delivered+, +Exception+, +Expired+.
    #
    # See status definition https://www.aftership.com/docs/api/4/delivery-status.
    #
    # @return [String]
    attr_reader :tag

    # Same as tag, except human-friendly:
    #
    # * +Pending+ => +Pending+
    # * +InfoReceived+ => +Info Received+
    # * +InTransit+ => +In Transit+
    # * +OutForDelivery+ => +Out For Delivery+
    # * +AttemptFail+ => +Attempt Failed+
    # * +Delivered+ => +Delivered+
    # * +Exception+ => +Exception+
    # * +Expired+ => +Expired+
    #
    # @return [String]
    attr_accessor :status

    # Title of the tracking.
    #
    # @return [String]
    attr_accessor :title

    # Number of attempts AfterShip tracks at courier's system.
    #
    # @return [Number]
    attr_accessor :tracked_count

    # Array of Checkpoint describes the checkpoint information.
    #
    # @return [Array<Checkpoint>]
    attr_reader :checkpoints

    # Better interface for a tracking.
    #
    # @param data [Hash] tracking hash
    def initialize(data)
      tracking_data = data.fetch(:tracking)
      load_attributes(tracking_data)
    end

    # Date and time of the tracking created.
    #
    # @return [DateTime]
    def created_at=(value)
      @created_at = DateTime.parse(value)
    end

    # Date and time of the tracking last updated.
    #
    # @return [DateTime]
    def updated_at=(value)
      @updated_at = DateTime.parse(value)
    end

    # Unique code of courier.
    #
    # @return [String]
    def slug=(value)
      @slug        = value
      self.courier = value.upcase
      @slug
    end

    # Expected delivery date (if any).
    #
    # @return [DateTime]
    def expected_delivery=(value)
      @expected_delivery = DateUtils.parse(value)
    end

    # Current status of tracking.
    #
    # Value: +Pending+, +InfoReceived+, +InTransit+, +OutForDelivery+,
    # +AttemptFail+, +Delivered+, +Exception+, +Expired+.
    #
    # See status definition https://www.aftership.com/docs/api/4/delivery-status.
    #
    # @return [String]
    def tag=(value)
      @tag        = value
      self.status = TAG_STATUS.fetch(value)
      @tag
    end

    # Array of Checkpoint describes the checkpoint information.
    #
    # @return [Array<Checkpoint>]
    def checkpoints=(value)
      @checkpoints = value.map { |data| Checkpoint.new(data) }
    end
  end
end

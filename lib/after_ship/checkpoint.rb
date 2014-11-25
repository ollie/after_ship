class AfterShip
  # Wrapper object for AfterShip tracking checkpoint:
  # https://www.aftership.com/docs/api/4/trackings/get-trackings-slug-tracking_number
  class Checkpoint
    include Attributes

    # Date and time of the tracking created.
    #
    # Should always be available.
    #
    # @return [DateTime]
    attr_reader :created_at

    # The unique code of courier for this checkpoint message.
    #
    # Should always be available.
    #
    # @return [String]
    attr_reader :slug

    # Courier name.
    #
    # Custom method!
    #
    # @return [String]
    attr_accessor :courier

    # Date and time of the checkpoint, provided by courier.
    #
    # Empty String,
    # YYYY-MM-DD,
    # YYYY-MM-DDTHH:MM:SS, or
    # YYYY-MM-DDTHH:MM:SS+TIMEZONE.
    #
    # Should always be available.
    #
    # @return [DateTime]
    attr_reader :checkpoint_time

    # Location info (if any).
    #
    # May be empty.
    #
    # @return [String]
    attr_accessor :city

    # Country ISO Alpha-3 (three letters) of the checkpoint.
    #
    # May be empty.
    #
    # @return [String]
    attr_accessor :country_iso3

    # Country name of the checkpoint, may also contain other location info.
    # Seems to be Alpha-2 code, e.g. +IN+, +DE+.
    #
    # May be empty.
    #
    # @return [String]
    attr_accessor :country_name

    # Checkpoint message
    #
    # Should always be available.
    #
    # @return [String]
    attr_accessor :message

    # Location info (if any).
    #
    # May be empty.
    #
    # @return [String]
    attr_accessor :state

    # Status of the checkpoint.
    #
    # Should always be available.
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

    # Location info (if any).
    #
    # May be empty.
    #
    # @return [String]
    attr_accessor :zip

    # Better interface for a checkpoint.
    #
    # @param data [Hash] checkpoint hash
    def initialize(data)
      load_attributes(data)
    end

    # The unique code of courier for this checkpoint message.
    #
    # Should always be available.
    #
    # @return [String]
    def slug=(value)
      @slug        = value
      self.courier = value.upcase
      @slug
    end

    # Date and time of the tracking created.
    #
    # @return [DateTime]
    def created_at=(value)
      @created_at = DateUtils.parse(value)
    end

    # Status of the checkpoint.
    #
    # Should always be available.
    #
    # @return [String]
    def tag=(value)
      @tag        = value
      self.status = TAG_STATUS.fetch(value)
      @tag
    end

    # Date and time of the checkpoint, provided by courier.
    #
    # @return [DateTime]
    def checkpoint_time=(value)
      @checkpoint_time = DateUtils.parse(value)
    end
  end
end

class AfterShip
  # Wrapper object for AfterShip tracking checkpoint:
  # https://www.aftership.com/docs/api/3.0/tracking/get-trackings-slug-tracking_number
  class Checkpoint
    include Attributes

    # Tracking number, e.g. +1ZA2207X6794165804+.
    #
    # Should always be available.
    #
    # @return [String]
    attr_accessor :slug

    # Date and time of the tracking created.
    #
    # Should always be available.
    #
    # @return [DateTime]
    attr_reader :created_at

    # Country name of the checkpoint, may also contain other location info.
    # Seems to be Alpha-2 code, e.g. +IN+, +DE+.
    #
    # Should always be available.
    #
    # @return [String]
    attr_accessor :country_name

    # Country ISO Alpha-3 (three letters) of the checkpoint.
    #
    # May be nil.
    #
    # @return [String]
    attr_accessor :country_iso3

    # Checkpoint message
    #
    # Should always be available.
    #
    # @return [String]
    attr_accessor :message

    # Status of the checkpoint.
    #
    # Should always be available.
    #
    # @return [String]
    attr_accessor :tag

    # Date and time of the checkpoint, provided by courier.
    #
    # Should always be available.
    #
    # @return [DateTime]
    attr_reader :checkpoint_time

    # Location info (if any).
    #
    # May be nil.
    #
    # @return [String]
    attr_accessor :state

    # Location info (if any).
    #
    # May be nil.
    #
    # @return [String]
    attr_accessor :zip

    # Better interface for a checkpoint.
    #
    # @param data [Hash] checkpoint hash
    def initialize(data)
      load_attributes(data)
    end

    # Date and time of the tracking created.
    #
    # @return [DateTime]
    def created_at=(value)
      @created_at = DateUtils.parse(value)
    end

    # Date and time of the checkpoint, provided by courier.
    #
    # @return [DateTime]
    def checkpoint_time=(value)
      @checkpoint_time = DateUtils.parse(value)
    end
  end
end

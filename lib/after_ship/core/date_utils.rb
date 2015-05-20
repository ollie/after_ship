class AfterShip
  # Simple utility class for parsing dates and datetimes.
  module DateUtils
    module_function

    # Date:
    #
    # +YYYYMMDD+
    DATE_PLAIN_REGEX = /
                   \A
                   \d{4}\d{2}\d{2}
                   \z
                 /x

    # Date:
    #
    # +YYYY-MM-DD+
    DATE_REGEX = /
                   \A
                   \d{4}-\d{2}-\d{2}
                   \z
                 /x

    # Datetime without zone:
    #
    # +YYYY-MM-DDTHH:MM:SS+
    DATETIME_REGEX = /
                       \A
                       \d{4}-\d{2}-\d{2}
                       T
                       \d{2}:\d{2}:\d{2}
                       \z
                     /x

    # Datetime with zone:
    #
    # +YYYY-MM-DDTHH:MM:SSZ+
    # +YYYY-MM-DDTHH:MM:SS+HH:MM+
    # +YYYY-MM-DDTHH:MM:SS-HH:MM+
    DATETIME_WITH_ZONE_REGEX = /
                                 \A
                                 \d{4}-\d{2}-\d{2}
                                 T
                                 \d{2}:\d{2}:\d{2}
                                 (Z|[+-]\d{2}:\d{2})
                                 \z
                               /x

    # Try to parse a date or datetime from a string.
    #
    # @param value [String]
    #   Empty String,
    #   YYYY-MM-DD,
    #   YYYY-MM-DDTHH:MM:SS,
    #   YYYY-MM-DDTHH:MM:SSZ,
    #   YYYY-MM-DDTHH:MM:SS+HH:MM or
    #   YYYY-MM-DDTHH:MM:SS-HH:MM.
    #
    def parse(value)
      case value
      when '', nil
        nil
      when DATE_PLAIN_REGEX, DATE_REGEX
        Date.parse(value)
      when DATETIME_REGEX, DATETIME_WITH_ZONE_REGEX
        DateTime.parse(value)
      else
        fail ArgumentError, "Invalid expected_delivery date #{ value.inspect }"
      end
    end
  end
end

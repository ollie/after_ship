class AfterShip
  # Response handling logic.
  module ErrorHandler
    module_function

    # These mean that the response is good.
    SUCCESS_CODES = [200, 201]

    # Map meta codes to error classes.
    CODE_TO_ERROR_MAP = {
      400  => Error::BadRequest,
      4001 => Error::InvalidJsonData,
      4002 => Error::InvalidJsonData,
      4003 => Error::TrackingAlreadyExists,
      4004 => Error::TrackingDoesNotExist,
      4005 => Error::TrackingNumberInvalid,
      4006 => Error::TrackingObjectRequired,
      4007 => Error::TrackingNumberRequired,
      4008 => Error::FieldInvalid,
      4009 => Error::FieldRequired,
      4010 => Error::SlugInvalid,
      4011 => Error::CourierFieldInvalid,
      4012 => Error::CourierNotDetected,
      4013 => Error::RetrackNotAllowed,
      4016 => Error::RetrackNotAllowed,
      4014 => Error::NotificationRequired,
      4015 => Error::IdInvalid,
      401  => Error::Unauthorized,
      403  => Error::Forbidden,
      404  => Error::NotFound,
      429  => Error::TooManyRequests,
      500  => Error::InternalError,
      502  => Error::InternalError,
      503  => Error::InternalError,
      504  => Error::InternalError
    }

    # Did it timeout? If the body empty?
    #
    # @param response [Typhoeus::Response]
    def precheck(response)
      fail Error::Timeout, "#{response.effective_url} cannot be reached" if
        response.timed_out?
    end

    # Check the meta code of the response. If it isn't 200 or 201, raise an
    # error.
    #
    # @param  meta          [Hash]
    # @option meta :code    [Fixnum]
    # @option meta :message [String, nil]
    # @option meta :type    [String, nil]
    def check(meta)
      code = meta.fetch(:code)

      return if SUCCESS_CODES.include?(code)

      error_class = error_class_for(code)
      fail error_class, meta[:message]
    end

    # Pick the corresponding error class for the code.
    def error_class_for(code)
      CODE_TO_ERROR_MAP[code] || Error::UnknownError
    end
  end
end

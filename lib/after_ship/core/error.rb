class AfterShip
  # Error classes.
  # https://www.aftership.com/docs/api/4/errors
  class Error < StandardError
    class BadRequest             < Error; end      # 400
    class InvalidJsonData        < BadRequest; end # 4001, 4002
    class TrackingAlreadyExists  < BadRequest; end # 4003
    class TrackingDoesNotExist   < BadRequest; end # 4004
    class TrackingNumberInvalid  < BadRequest; end # 4005
    class TrackingObjectRequired < BadRequest; end # 4006
    class TrackingNumberRequired < BadRequest; end # 4007
    class FieldInvalid           < BadRequest; end # 4008
    class FieldRequired          < BadRequest; end # 4009
    class SlugInvalid            < BadRequest; end # 4010
    class CourierFieldInvalid    < BadRequest; end # 4011
    class CourierNotDetected     < BadRequest; end # 4012
    class RetrackNotAllowed      < BadRequest; end # 4013, 4016
    class NotificationRequired   < BadRequest; end # 4014
    class IdInvalid              < BadRequest; end # 4015
    class Unauthorized           < Error; end      # 401
    class Forbidden              < Error; end      # 403
    class NotFound               < Error; end      # 404
    class TooManyRequests        < Error; end      # 429
    class InternalError          < Error; end      # 500, 502, 503, 504

    class UnknownError           < Error; end      # Huh?
    class Timeout                < Error; end      # Uh oh.
  end
end

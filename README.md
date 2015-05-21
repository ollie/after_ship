# AfterShip [![Build Status](https://travis-ci.org/ollie/after_ship.svg?branch=master)](https://travis-ci.org/ollie/after_ship) [![Code Climate](https://codeclimate.com/github/ollie/after_ship/badges/gpa.svg)](https://codeclimate.com/github/ollie/after_ship)

A smallish library to talking to AfterShip via v4 API. It currently supports
those methods:

* Get a list of trackings,
* Get a particular tracking (with tracking_number + slug combination),
* Create a tracking,
* Update a tracking (with tracking_number + slug combination),
* Get activated couriers.

I may implement other methods if I need them or if you are interested.

You will need an AfterShip API key, see here https://www.aftership.com/docs/api/4.
The JSON is parsed by MultiJson (https://github.com/intridea/multi_json) so
you may want to drop in your favorite JSON engine.

## Usage

### Init the client

```ruby
client = AfterShip.new(api_key: 'your-aftership-api-key')
```

### [Get a list of trackings][trackings_url]

```ruby
trackings = client.trackings

trackings.each do |tracking|
  puts tracking.tracking_number

  tracking.checkpoints.each do |checkpoint|
    puts "#{ checkpoint.city } #{ checkpoint.checkpoint_time }"
  end
end
```

Returns a list of `AfterShip::Tracking` objects:

```
[
  #<AfterShip::Tracking ...>,
  #<AfterShip::Tracking ...>,
  ...
]
```

### [Get a tracking][tracking_url]

```ruby
tracking = client.tracking('tracking-number', 'ups')

puts tracking.tracking_number

tracking.checkpoints.each do |checkpoint|
  puts "#{ checkpoint.city } #{ checkpoint.checkpoint_time }"
end
```

Returns a `AfterShip::Tracking` object or raises a `AfterShip::Error::NotFound` if not found:

```
#<AfterShip::Tracking:0x007f838ef44e58
  @active=false,
  @android=[],
  @courier="UPS",
  @created_at=#<DateTime: 2014-11-19T15:16:17+00:00 ...>,
  @custom_fields={},
  @customer_name=nil,
  @delivery_time=8,
  @destination_country_iso3="USA",
  @emails=[],
  @expected_delivery=nil,
  @id="546cb4414a1a2097122ae7b1",
  @ios=[],
  @order_id="PL-66448782",
  @order_id_path=nil,
  @origin_country_iso3="IND",
  @shipment_package_count=1,
  @shipment_type="UPS SAVER",
  @shipment_weight=0.5,
  @shipment_weight_unit="kg",
  @signed_by="MET CUSTOM",
  @slug="ups",
  @smses=[],
  @source="api",
  @status="Delivered",
  @tag="Delivered",
  @title="1ZA2207X0490715335",
  @tracked_count=6,
  @tracking_account_number=nil,
  @tracking_number="1ZA2207X0490715335",
  @tracking_postal_code=nil,
  @tracking_ship_date=nil,
  @unique_token="-y6ziF438",
  @updated_at=#<DateTime: 2014-11-19T22:12:32+00:00 ...>,
  @checkpoints=[
    #<AfterShip::Checkpoint:0x007f838ef57d50
      @checkpoint_time=
      #<DateTime: 2014-11-11T19:12:00+00:00 ...>,
      @city="MUMBAI",
      @country_iso3=nil,
      @country_name="IN",
      @courier="UPS",
      @created_at=
      #<DateTime: 2014-11-19T15:16:17+00:00 ...>,
      @message="PICKUP SCAN",
      @slug="ups",
      @state=nil,
      @status="In Transit",
      @tag="InTransit",
      @zip=nil>,
    #<AfterShip::Checkpoint ...>,
    ...
  ]
>
```

### [Create a new tracking][create_tracking_url]

```ruby
tracking = client.create_tracking('tracking-number', 'ups', order_id: 'external-id')
```

Returns a `AfterShip::Tracking` object or raises a `AfterShip::Error::TrackingAlreadyExists`
if tracking already exists:

```
#<AfterShip::Tracking ...>
```

### [Update a tracking][update_tracking_url]

```ruby
tracking = client.update_tracking('tracking-number', 'ups', order_id: 'external-id')
```

Returns a `AfterShip::Tracking` object or raises a `AfterShip::Error::NotFound` if not found:

```
#<AfterShip::Tracking ...>
```

### [Get activated couriers][couriers_url]

```ruby
couriers = client.couriers

couriers.each do |courier|
  puts "#{ courier.name } #{ courier.other_name }"
end
```

Returns a list of `AfterShip::Courier` objects:

```
[
  #<AfterShip::Courier:0x007fa2771d4bf8
    @name="USPS",
    @other_name="United States Postal Service",
    @phone="+1 800-275-8777",
    @required_fields=[],
    @slug="usps",
    @web_url="https://www.usps.com">,
  #<AfterShip::Courier ...>
  ...
]
```

### [Errors][errors_url]

The library can respond with all of the v4 errors. The first colum is
HTTP status code, the second meta code. The indentation indicates inheritance.

```
| HTTP | Meta | Error class                                |
|------+------+--------------------------------------------|
| 400  | 400  | AfterShip::Error::BadRequest               |
| 400  | 4001 |   AfterShip::Error::InvalidJsonData        |
| 400  | 4002 |   AfterShip::Error::InvalidJsonData        |
| 400  | 4003 |   AfterShip::Error::TrackingAlreadyExists  |
| 400  | 4004 |   AfterShip::Error::TrackingDoesNotExist   |
| 400  | 4005 |   AfterShip::Error::TrackingNumberInvalid  |
| 400  | 4006 |   AfterShip::Error::TrackingObjectRequired |
| 400  | 4007 |   AfterShip::Error::TrackingNumberRequired |
| 400  | 4008 |   AfterShip::Error::FieldInvalid           |
| 400  | 4009 |   AfterShip::Error::FieldRequired          |
| 400  | 4010 |   AfterShip::Error::SlugInvalid            |
| 400  | 4011 |   AfterShip::Error::CourierFieldInvalid    |
| 400  | 4012 |   AfterShip::Error::CourierNotDetected     |
| 400  | 4013 |   AfterShip::Error::RetrackNotAllowed      |
| 400  | 4016 |   AfterShip::Error::RetrackNotAllowed      |
| 400  | 4014 |   AfterShip::Error::NotificationRequired   |
| 400  | 4015 |   AfterShip::Error::IdInvalid              |
| 401  | 401  | AfterShip::Error::Unauthorized             |
| 403  | 403  | AfterShip::Error::Forbidden                |
| 404  | 404  | AfterShip::Error::NotFound                 |
| 429  | 429  | AfterShip::Error::TooManyRequests          |
| 500  | 500  | AfterShip::Error::InternalError            |
| 502  | 502  | AfterShip::Error::InternalError            |
| 503  | 503  | AfterShip::Error::InternalError            |
| 504  | 504  | AfterShip::Error::InternalError            |
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'after_ship'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install after_ship

## Contributing

0. E-mail me or create an issue.
1. Fork it (https://github.com/ollie/after_ship/fork).
2. Create your feature branch (`git checkout -b my-new-feature`).
3. Commit your changes (`git commit -am 'Add some feature'`).
4. Push to the branch (`git push origin my-new-feature`).
5. Create a new Pull Request.

[trackings_url]:       https://www.aftership.com/docs/api/4/trackings/get-trackings
[tracking_url]:        https://www.aftership.com/docs/api/4/trackings/get-trackings-slug-tracking_number
[create_tracking_url]: https://www.aftership.com/docs/api/4/trackings/post-trackings
[update_tracking_url]: https://www.aftership.com/docs/api/4/trackings/put-trackings-slug-tracking_number
[couriers_url]:        https://www.aftership.com/docs/api/4/couriers/get-couriers
[errors_url]:          https://www.aftership.com/docs/api/4/errors

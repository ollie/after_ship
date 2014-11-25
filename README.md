# AfterShip

[![Build Status](https://travis-ci.org/ollie/after_ship.svg?branch=master)](https://travis-ci.org/ollie/after_ship)

A smallish library to talking to AfterShip via v4 API.

You will need an AfterShip API key, see here https://www.aftership.com/docs/api/4.
The JSON is parsed by MultiJson (https://github.com/intridea/multi_json) so
you may want to drop in your favorite JSON engine.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'after_ship', git: 'https://github.com/ollie/after_ship.git'
```

And then execute:

    $ bundle

## Usage

Init the client:

```ruby
client = AfterShip.new(api_key: 'your-aftership-api-key')
```

Get a list of trackings
https://www.aftership.com/docs/api/4/trackings/get-trackings

```ruby
client.trackings

# Will return list of Tracking objects:

[
  #<AfterShip::Tracking ...>,
  #<AfterShip::Tracking ...>,
  ...
]
```

Get a tracking
https://www.aftership.com/docs/api/4/trackings/get-trackings-slug-tracking_number

```ruby
client.tracking('tracking-number', 'ups')

# Will return Tracking object or raise AfterShip::Error::NotFound:

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

Create a new tracking
https://www.aftership.com/docs/api/4/trackings/post-trackings

```ruby
client.create_tracking('tracking-number', 'ups', order_id: 'external-id')

# Will return Tracking object or raise
# AfterShip::Error::TrackingAlreadyExists:

#<AfterShip::Tracking ...>
```

Update a tracking
https://www.aftership.com/docs/api/4/trackings/put-trackings-slug-tracking_number

```ruby
client.update_tracking('tracking-number', 'ups', order_id: 'external-id')

# Will return Tracking object or raise
# AfterShip::Error::TrackingAlreadyExists:

#<AfterShip::Tracking ...>
```

Get activated couriers
https://www.aftership.com/docs/api/4/couriers/get-couriers

```ruby
client.couriers

# Will return list of Courier objects:

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

## Contributing

0. E-mail me or create an issue
1. Fork it (https://github.com/ollie/after_ship/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

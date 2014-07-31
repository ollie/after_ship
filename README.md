# AfterShip

[![Build Status](https://travis-ci.org/ollie/after_ship.svg?branch=master)](https://travis-ci.org/ollie/after_ship)

A smallish library to talking to AfterShip via v3 API.

You will need an AfterShip API key, see here https://www.aftership.com/docs/api/3.0.
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
https://www.aftership.com/docs/api/3.0/tracking/get-trackings

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
https://www.aftership.com/docs/api/3.0/tracking/get-trackings-slug-tracking_number

```ruby
client.tracking('tracking-number', 'ups')

# Will return Tracking object or raise AfterShip::ResourceNotFoundError
# if not exists:

#<AfterShip::Tracking:0x007fe555bd9560
  @active=false,
  @courier="UPS",
  @created_at=#<DateTime: 2014-05-08T15:25:01+00:00 ((2456786j,55501s,0n),+0s,2299161j)>,
  @updated_at=#<DateTime: 2014-07-18T09:00:47+00:00 ((2456857j,32447s,0n),+0s,2299161j)>>
  @custom_fields={},
  @customer_name=nil,
  @destination_country_iso3="USA",
  @emails=[],
  @expected_delivery=nil,
  @order_id="PL-12480166",
  @order_id_path=nil,
  @origin_country_iso3="IND",
  @shipment_package_count=0,
  @shipment_type="EXPEDITED",
  @signed_by="FRONT DOOR",
  @slug="ups",
  @smses=[],
  @source="api",
  @status="Delivered",
  @tag="Delivered",
  @title="1ZA2207X6790326683",
  @tracked_count=47,
  @tracking_number="1ZA2207X6790326683",
  @unique_token="ly9ueXUJC",
  @checkpoints=[
    #<AfterShip::Checkpoint:0x007fe555bb0340
      @checkpoint_time=#<DateTime: 2014-05-12T14:07:00+00:00 ((2456790j,50820s,0n),+0s,2299161j)>,
      @city="NEW YORK",
      @country_iso3=nil,
      @country_name="US",
      @courier="UPS",
      @created_at=#<DateTime: 2014-05-12T18:34:32+00:00 ((2456790j,66872s,0n),+0s,2299161j)>,
      @message="DELIVERED",
      @slug="ups",
      @state="NY",
      @status="Delivered",
      @tag="Delivered",
      @zip="10075">
    #<AfterShip::Checkpoint ...>,
    ...
  ]>
```

Create a new tracking
https://www.aftership.com/docs/api/3.0/tracking/post-trackings

```ruby
client.create_tracking('tracking-number', 'ups', order_id: 'external-id')

# Will return Tracking object or raise AfterShip::InvalidArgumentError
# if it exists:

#<AfterShip::Tracking ...>
```

Update a tracking
https://www.aftership.com/docs/api/3.0/tracking/put-trackings-slug-tracking_number

```ruby
client.update_tracking('tracking-number', 'ups', order_id: 'external-id')
```

## Contributing

0. E-mail me or create an issue
1. Fork it (https://github.com/ollie/after_ship/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

# AfterShip

A smallish library to talking to AfterShip via v3 API.

You will need an AfterShip API key, see here https://www.aftership.com/docs/api/3.0.
The JSON is parsed by MultiJson (https://github.com/intridea/multi_json) so
you may want to drop in your favorite JSON engine.

## Installation

Add this line to your application's Gemfile:

    gem 'after_ship', git: 'https://github.com/ollie/after_ship.git'

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

# Will return JSON:

{
  ...,
  data: {
    ...
    trackings: [
      {
        ...
      },
      ...
    ]
  }
}
```

Get a tracking
https://www.aftership.com/docs/api/3.0/tracking/get-trackings-slug-tracking_number

```ruby
client.tracking('tracking-number', 'ups')

# Will return JSON or raise AfterShip::ResourceNotFoundError if not exists:

{
  ...,
  data: {
    tracking: {
      ...
    }
  }
}
```

Create a new tracking
https://www.aftership.com/docs/api/3.0/tracking/post-trackings

```ruby
client.create_tracking('tracking-number', 'ups', order_id: 'external-id')

# Will return JSON or raise AfterShip::InvalidArgumentError if it exists:

{
  ...,
  data: {
    tracking: {
      ...
    }
  }
}
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

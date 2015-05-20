# Get trackings
WebMock
  .stub_request(
    :get,
    'https://api.aftership.com/v4/trackings'
  )
  .with(
    headers: { 'Aftership-Api-Key' => 'key' }
  )
  .to_return(
    status: 200,
    body:   File.open('spec/requests/trackings.json')
  )

# Get a tracking
WebMock
  .stub_request(
    :get,
    'https://api.aftership.com/v4/trackings/ups/delivered'
  )
  .with(
    headers: { 'Aftership-Api-Key' => 'key' }
  )
  .to_return(
    status: 200,
    body:   File.open('spec/requests/tracking/delivered.json')
  )

# Create a tracking
WebMock
  .stub_request(
    :post,
    'https://api.aftership.com/v4/trackings'
  )
  .with(
    headers: { 'Aftership-Api-Key' => 'key' },
    body: MultiJson.dump(
      'tracking' => {
        'tracking_number' => 'created',
        'slug'            => 'ups',
        'order_id'        => 'external-id'
      }
    )
  )
  .to_return(
    status: 200,
    body:   File.open('spec/requests/tracking/created.json')
  )

# Update a tracking
WebMock
  .stub_request(
    :put,
    'https://api.aftership.com/v4/trackings/ups/updated'
  )
  .with(
    headers: { 'Aftership-Api-Key' => 'key' },
    body: MultiJson.dump(
      'tracking' => {
        'order_id'        => 'external-id'
      }
    )
  )
  .to_return(
    status: 200,
    body:   File.open('spec/requests/tracking/created.json')
  )

# Couriers
WebMock
  .stub_request(
    :get,
    'https://api.aftership.com/v4/couriers'
  )
  .with(
    headers: { 'Aftership-Api-Key' => 'key' }
  )
  .to_return(
    status: 200,
    body:   File.open('spec/requests/couriers.json')
  )

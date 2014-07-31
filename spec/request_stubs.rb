# trackings
WebMock.stub_request(
  :get,
  'https://api.aftership.com/v3/trackings'
  ).with(
    body:    '{}',
    headers: { 'Aftership-Api-Key' => 'key' }
  ).to_return(
    status: 200,
    body:   %({"meta":{"code":200},"data":{"trackings":[{"slug":"ups"}]}})
  )

# tracking with real delivered data (simple)
WebMock.stub_request(
  :get,
  'https://api.aftership.com/v3/trackings/ups/delivered-ok'
  ).with(
    body:    '{}',
    headers: { 'Aftership-Api-Key' => 'key' }
  ).to_return(
    status: 200,
    body:   File.open('spec/requests/tracking/delivered_ok.json')
  )

# tracking with real delivered data (a lot of checkpoints)
WebMock.stub_request(
  :get,
  'https://api.aftership.com/v3/trackings/ups/delivered-wild'
  ).with(
    body:    '{}',
    headers: { 'Aftership-Api-Key' => 'key' }
  ).to_return(
    status: 200,
    body:   File.open('spec/requests/tracking/delivered_wild.json')
  )

# tracking with real in-transit data
WebMock.stub_request(
  :get,
  'https://api.aftership.com/v3/trackings/usps/in-transit'
  ).with(
    body:    '{}',
    headers: { 'Aftership-Api-Key' => 'key' }
  ).to_return(
    status: 200,
    body:   File.open('spec/requests/tracking/in_transit.json')
  )

# tracking
WebMock.stub_request(
  :get,
  'https://api.aftership.com/v3/trackings/ups/ABC123'
  ).with(
    body:    '{}',
    headers: { 'Aftership-Api-Key' => 'key' }
  ).to_return(
    status: 200,
    body:   %({"meta":{"code":200},"data":{"tracking":{}}})
  )

[201, 400, 401, 402, 404, 409, 429, 500, 502, 503, 504, 666].each do |code|
  WebMock.stub_request(
    :get,
    "https://api.aftership.com/v3/trackings/ups/#{ code }"
    ).with(
      body:    '{}',
      headers: { 'Aftership-Api-Key' => 'key' }
    ).to_return(
      status: 200,
      body:   %({"meta":{"code":#{code}},"data":{"tracking":{"slug":"ups"}}})
    )
end

# create_tracking
WebMock.stub_request(
  :post,
  'https://api.aftership.com/v3/trackings'
  ).with(
    body:    %({"tracking":{"tracking_number":"ABC123","slug":"ups"}}),
    headers: { 'Aftership-Api-Key' => 'key' }
  ).to_return(
    status: 200,
    body:   %({"meta":{"code":200},"data":{"tracking":{"slug":"ups"}}})
  )

WebMock.stub_request(
  :post,
  'https://api.aftership.com/v3/trackings'
  ).with(
    body:    %({"tracking":{"tracking_number":"ABC123","slug":"ups","order_id":"1234"}}), # rubocop:disable Style/LineLength
    headers: { 'Aftership-Api-Key' => 'key' }
  ).to_return(
    status: 200,
    body:   %({"meta":{"code":200},"data":{"tracking":{"slug":"ups"}}})
  )

# update_tracking

WebMock.stub_request(
  :put,
  'https://api.aftership.com/v3/trackings/ups/ABC123'
  ).with(
    body:    %({"tracking":{"order_id":"1234"}}),
    headers: { 'Aftership-Api-Key' => 'key' }
  ).to_return(
    status: 200,
    body:   %({"meta":{"code":200},"data":{"tracking":{"slug":"ups"}}})
  )

## App-specific AfterShip tests

# create_tracking
WebMock.stub_request(
  :post,
  'https://api.aftership.com/v3/trackings'
  ).with(
    body:    %({"tracking":{"tracking_number":"ABC123","slug":"ups","order_id":"1234"}}), # rubocop:disable Style/LineLength
    headers: { 'Aftership-Api-Key' => 'key' }
  ).to_return(
    status: 200,
    body:   %({"meta":{"code":200},"data":{"tracking":{"slug":"ups"}}})
  )

WebMock.stub_request(
  :post,
  'https://api.aftership.com/v3/trackings'
  ).with(
    body:    %({"tracking":{"tracking_number":"EXISTING","slug":"ups","order_id":"1234"}}), # rubocop:disable Style/LineLength
    headers: { 'Aftership-Api-Key' => 'key' }
  ).to_return(
    status: 200,
    body:   %({"meta":{"code":409}})
  )

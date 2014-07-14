# trackings
WebMock.stub_request(
  :get,
  'https://api.aftership.com/v3/trackings'
  ).with(
    body:    '{}',
    headers: { 'Aftership-Api-Key' => 'key' }
  ).to_return(
    status: 200,
    body:   %({"meta":{"code":200}})
  )

# tracking
WebMock.stub_request(
  :get,
  %r{https://api.aftership.com/v3/trackings/ups/.+}
  ).with(
    body:    '{}',
    headers: { 'Aftership-Api-Key' => 'key' }
  ).to_return(
    status: 200,
    body:   %({"meta":{"code":200}})
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
      body:   %({"meta":{"code":#{code}}})
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
    body:   %({"meta":{"code":200}})
  )

WebMock.stub_request(
  :post,
  'https://api.aftership.com/v3/trackings'
  ).with(
    body:    %({"tracking":{"tracking_number":"ABC123","slug":"ups","order_id":"1234"}}), # rubocop:disable Style/LineLength
    headers: { 'Aftership-Api-Key' => 'key' }
  ).to_return(
    status: 200,
    body:   %({"meta":{"code":200}})
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
    body:   %({"meta":{"code":200}})
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
    body:   %({"meta":{"code":200}})
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

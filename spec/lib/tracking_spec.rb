require 'spec_helper'

RSpec.describe AfterShip::Tracking do
  before do
    @client = AfterShip.new(api_key: 'key')
  end

  it 'builds delivered Tracking (simple)' do
    tracking = @client.tracking('delivered-ok', 'ups')
    expect(tracking).to be_a(AfterShip::Tracking)
    expect(tracking.checkpoints.size).to eq(15)
  end

  it 'builds delivered Tracking (quite crazy)' do
    tracking = @client.tracking('delivered-wild', 'ups')
    expect(tracking).to be_a(AfterShip::Tracking)
    expect(tracking.checkpoints.size).to eq(41)
  end

  it 'builds in-transit Tracking' do
    tracking = @client.tracking('in-transit', 'usps')
    expect(tracking).to be_a(AfterShip::Tracking)
    expect(tracking.checkpoints.size).to eq(27)
    expect(tracking.expected_delivery.to_s).to eq('2014-07-02T00:00:00+00:00')
  end
end

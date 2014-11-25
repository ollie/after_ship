require 'spec_helper'

RSpec.describe AfterShip do
  let(:client) { AfterShip.new(api_key: 'key') }

  it 'trackings' do
    trackings = client.trackings
    expect(trackings.size).to eq(2)
  end

  it 'trackings with debug' do
    AfterShip.debug = true

    trackings = client.trackings
    expect(trackings.size).to eq(2)

    AfterShip.debug = nil
  end

  it 'tracking' do
    tracking = client.tracking('delivered', 'ups')
    expect(tracking.tracking_number).to eq('1ZA2207X0444990982')
    expect(tracking.checkpoints.size).to eq(15)
  end

  it 'create_tracking' do
    tracking = client.create_tracking('created', 'ups', order_id: 'external-id')
    expect(tracking.tracking_number).to eq('1Z0659120300549388')
  end

  it 'update_tracking' do
    tracking = client.update_tracking('updated', 'ups', order_id: 'external-id')
    expect(tracking.tracking_number).to eq('1Z0659120300549388')
  end

  it 'couriers' do
    couriers = client.couriers
    expect(couriers.size).to eq(4)
  end
end

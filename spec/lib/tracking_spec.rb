require 'spec_helper'

RSpec.describe AfterShip::Tracking do
  before do
    @client = AfterShip.new(api_key: 'key')
  end

  context 'Real data' do
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

  it 'has courier' do
    data     = { slug: 'ups' }
    tracking = AfterShip::Tracking.new(data)
    expect(tracking.courier).to eq('UPS')
  end

  context 'status' do
    it 'Pending' do
      data     = { tag: 'Pending' }
      tracking = AfterShip::Tracking.new(data)
      expect(tracking.status).to eq('Pending')
    end

    it 'InfoReceived' do
      data     = { tag: 'InfoReceived' }
      tracking = AfterShip::Tracking.new(data)
      expect(tracking.status).to eq('Info Received')
    end

    it 'InTransit' do
      data     = { tag: 'InTransit' }
      tracking = AfterShip::Tracking.new(data)
      expect(tracking.status).to eq('In Transit')
    end

    it 'OutForDelivery' do
      data     = { tag: 'OutForDelivery' }
      tracking = AfterShip::Tracking.new(data)
      expect(tracking.status).to eq('Out for Delivery')
    end

    it 'AttemptFail' do
      data     = { tag: 'AttemptFail' }
      tracking = AfterShip::Tracking.new(data)
      expect(tracking.status).to eq('Attempt Failed')
    end

    it 'Delivered' do
      data     = { tag: 'Delivered' }
      tracking = AfterShip::Tracking.new(data)
      expect(tracking.status).to eq('Delivered')
    end

    it 'Exception' do
      data     = { tag: 'Exception' }
      tracking = AfterShip::Tracking.new(data)
      expect(tracking.status).to eq('Exception')
    end

    it 'Expired' do
      data     = { tag: 'Expired' }
      tracking = AfterShip::Tracking.new(data)
      expect(tracking.status).to eq('Expired')
    end

    it 'error' do
      data = { tag: 'error' }
      expect { AfterShip::Tracking.new(data) }.to raise_error(KeyError)
    end
  end
end

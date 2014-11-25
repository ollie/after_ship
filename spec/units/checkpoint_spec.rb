require 'spec_helper'

RSpec.describe AfterShip::Checkpoint do
  context 'Attributes' do
    it 'created_at' do
      data     = { created_at: '2014-10-30T10:05:48' }
      tracking = AfterShip::Checkpoint.new(data)
      expect(tracking.created_at).to be_a(DateTime)
      expect(tracking.created_at.to_s).to eq('2014-10-30T10:05:48+00:00')
    end

    it 'slug' do
      data     = { slug: 'ups' }
      tracking = AfterShip::Checkpoint.new(data)
      expect(tracking.slug).to eq('ups')
    end

    it 'courier' do
      data     = { slug: 'ups' }
      tracking = AfterShip::Checkpoint.new(data)
      expect(tracking.courier).to eq('UPS')
    end

    it 'checkpoint_time' do
      data     = { checkpoint_time: '2014-10-30T10:05:48+00:00' }
      tracking = AfterShip::Checkpoint.new(data)
      expect(tracking.checkpoint_time).to be_a(DateTime)
      expect(tracking.checkpoint_time.to_s)
        .to eq('2014-10-30T10:05:48+00:00')
    end

    it 'city' do
      data     = { city: 'MUMBAI' }
      tracking = AfterShip::Checkpoint.new(data)
      expect(tracking.city).to eq('MUMBAI')
    end

    it 'country_iso3' do
      data     = { country_iso3: 'IND' }
      tracking = AfterShip::Checkpoint.new(data)
      expect(tracking.country_iso3).to eq('IND')
    end

    it 'country_name' do
      data     = { country_name: 'IN' }
      tracking = AfterShip::Checkpoint.new(data)
      expect(tracking.country_name).to eq('IN')
    end

    it 'message' do
      data     = { message: 'PICKUP SCAN' }
      tracking = AfterShip::Checkpoint.new(data)
      expect(tracking.message).to eq('PICKUP SCAN')
    end

    it 'state' do
      data     = { state: 'CA' }
      tracking = AfterShip::Checkpoint.new(data)
      expect(tracking.state).to eq('CA')
    end

    it 'tag' do
      data     = { tag: 'Delivered' }
      tracking = AfterShip::Checkpoint.new(data)
      expect(tracking.tag).to eq('Delivered')
    end

    it 'status' do
      data     = { tag: 'Delivered' }
      tracking = AfterShip::Checkpoint.new(data)
      expect(tracking.status).to eq('Delivered')
    end

    it 'zip' do
      data     = { zip: '94110' }
      tracking = AfterShip::Checkpoint.new(data)
      expect(tracking.zip).to eq('94110')
    end
  end

  context 'status' do
    it 'Pending' do
      data       = { tag: 'Pending' }
      checkpoint = AfterShip::Checkpoint.new(data)
      expect(checkpoint.status).to eq('Pending')
    end

    it 'InfoReceived' do
      data       = { tag: 'InfoReceived' }
      checkpoint = AfterShip::Checkpoint.new(data)
      expect(checkpoint.status).to eq('Info Received')
    end

    it 'InTransit' do
      data       = { tag: 'InTransit' }
      checkpoint = AfterShip::Checkpoint.new(data)
      expect(checkpoint.status).to eq('In Transit')
    end

    it 'OutForDelivery' do
      data       = { tag: 'OutForDelivery' }
      checkpoint = AfterShip::Checkpoint.new(data)
      expect(checkpoint.status).to eq('Out for Delivery')
    end

    it 'AttemptFail' do
      data       = { tag: 'AttemptFail' }
      checkpoint = AfterShip::Checkpoint.new(data)
      expect(checkpoint.status).to eq('Attempt Failed')
    end

    it 'Delivered' do
      data       = { tag: 'Delivered' }
      checkpoint = AfterShip::Checkpoint.new(data)
      expect(checkpoint.status).to eq('Delivered')
    end

    it 'Exception' do
      data       = { tag: 'Exception' }
      checkpoint = AfterShip::Checkpoint.new(data)
      expect(checkpoint.status).to eq('Exception')
    end

    it 'Expired' do
      data       = { tag: 'Expired' }
      checkpoint = AfterShip::Checkpoint.new(data)
      expect(checkpoint.status).to eq('Expired')
    end

    it 'error' do
      data = { tag: 'error' }
      expect { AfterShip::Checkpoint.new(data) }.to raise_error(KeyError)
    end
  end
end

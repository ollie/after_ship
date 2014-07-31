require 'spec_helper'

RSpec.describe AfterShip::Tracking do
  before do
    @client = AfterShip.new(api_key: 'key')
  end

  context 'Attributes' do
    before do
      data = {
        checkpoints: [
          {
            slug:             'ups',
            city:             'Mumbai',
            created_at:       '2014-05-06T08:03:52+00:00',
            country_name:     'IN',
            message:          'BILLING INFORMATION RECEIVED',
            country_iso3:     'IND',
            tag:              'InfoReceived',
            checkpoint_time:  '2014-05-01T10:33:38',
            coordinates:      [],
            state:            nil,
            zip:              nil
          }
        ]
      }

      tracking    = AfterShip::Tracking.new(data)
      @checkpoint = tracking.checkpoints.first
    end

    it 'slug' do
      expect(@checkpoint.slug).to eq('ups')
    end

    it 'city' do
      expect(@checkpoint.city).to eq('Mumbai')
    end

    it 'courier' do
      expect(@checkpoint.courier).to eq('UPS')
    end

    it 'created_at is a DateTime' do
      expect(@checkpoint.created_at).to be_a(DateTime)
    end

    it 'created_at matches pattern' do
      expect(@checkpoint.created_at.to_s).to eq('2014-05-06T08:03:52+00:00')
    end

    it 'country_name' do
      expect(@checkpoint.country_name).to eq('IN')
    end

    it 'country_iso3' do
      expect(@checkpoint.country_iso3).to eq('IND')
    end

    it 'message' do
      expect(@checkpoint.message).to eq('BILLING INFORMATION RECEIVED')
    end

    it 'tag' do
      expect(@checkpoint.tag).to eq('InfoReceived')
    end

    it 'checkpoint_time is a DateTime' do
      expect(@checkpoint.checkpoint_time).to be_a(DateTime)
    end

    it 'checkpoint_time matches pattern' do
      expect(@checkpoint.checkpoint_time.to_s).to eq('2014-05-01T10:33:38+00:00')
    end

    it 'state' do
      expect(@checkpoint.state).to be_nil
    end

    it 'zip' do
      expect(@checkpoint.zip).to be_nil
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

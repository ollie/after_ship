require 'spec_helper'

RSpec.describe AfterShip::Tracking do
  context 'Attributes' do
    it 'created_at' do
      data     = { created_at: '2014-10-30T10:05:48' }
      tracking = AfterShip::Tracking.new(data)
      expect(tracking.created_at).to be_a(DateTime)
      expect(tracking.created_at.to_s).to eq('2014-10-30T10:05:48+00:00')
    end

    it 'updated_at' do
      data     = { updated_at: '2014-10-30T10:05:48' }
      tracking = AfterShip::Tracking.new(data)
      expect(tracking.updated_at).to be_a(DateTime)
      expect(tracking.updated_at.to_s).to eq('2014-10-30T10:05:48+00:00')
    end

    it 'id' do
      data     = { id: '5457a109bb8bce546b7abafa' }
      tracking = AfterShip::Tracking.new(data)
      expect(tracking.id).to eq('5457a109bb8bce546b7abafa')
    end

    it 'tracking_number' do
      data     = { tracking_number: '1ZA2207X0444990982' }
      tracking = AfterShip::Tracking.new(data)
      expect(tracking.tracking_number).to eq('1ZA2207X0444990982')
    end

    it 'tracking_postal_code' do
      data     = { tracking_postal_code: '???' }
      tracking = AfterShip::Tracking.new(data)
      expect(tracking.tracking_postal_code).to eq('???')
    end

    it 'tracking_ship_date' do
      data     = { tracking_ship_date: '20141124' }
      tracking = AfterShip::Tracking.new(data)
      expect(tracking.tracking_ship_date).to be_a(Date)
      expect(tracking.tracking_ship_date.to_s)
        .to eq('2014-11-24')
    end

    it 'tracking_account_number' do
      data     = { tracking_account_number: '???' }
      tracking = AfterShip::Tracking.new(data)
      expect(tracking.tracking_account_number).to eq('???')
    end

    it 'slug' do
      data     = { slug: 'ups' }
      tracking = AfterShip::Tracking.new(data)
      expect(tracking.slug).to eq('ups')
    end

    it 'courier' do
      data     = { slug: 'ups' }
      tracking = AfterShip::Tracking.new(data)
      expect(tracking.courier).to eq('UPS')
    end

    it 'active' do
      data     = { active: false }
      tracking = AfterShip::Tracking.new(data)
      expect(tracking.active).to eq(false)
    end

    it 'android' do
      data     = { android: [] }
      tracking = AfterShip::Tracking.new(data)
      expect(tracking.android).to eq([])
    end

    it 'custom_fields' do
      data     = { custom_fields: [] }
      tracking = AfterShip::Tracking.new(data)
      expect(tracking.custom_fields).to eq([])
    end

    it 'customer_name' do
      data     = { customer_name: nil }
      tracking = AfterShip::Tracking.new(data)
      expect(tracking.customer_name).to eq(nil)
    end

    it 'delivery_time' do
      data     = { delivery_time: 4 }
      tracking = AfterShip::Tracking.new(data)
      expect(tracking.delivery_time).to eq(4)
    end

    it 'destination_country_iso3' do
      data     = { destination_country_iso3: 'USA' }
      tracking = AfterShip::Tracking.new(data)
      expect(tracking.destination_country_iso3).to eq('USA')
    end

    it 'emails' do
      data     = { emails: [] }
      tracking = AfterShip::Tracking.new(data)
      expect(tracking.emails).to eq([])
    end

    it 'expected_delivery' do
      data     = { expected_delivery: '2014-10-30T10:05:48+00:00' }
      tracking = AfterShip::Tracking.new(data)
      expect(tracking.expected_delivery).to be_a(DateTime)
      expect(tracking.expected_delivery.to_s)
        .to eq('2014-10-30T10:05:48+00:00')
    end

    it 'ios' do
      data     = { ios: [] }
      tracking = AfterShip::Tracking.new(data)
      expect(tracking.ios).to eq([])
    end

    it 'order_id' do
      data     = { order_id: 'order-id' }
      tracking = AfterShip::Tracking.new(data)
      expect(tracking.order_id).to eq('order-id')
    end

    it 'order_id_path' do
      data     = { order_id_path: '???' }
      tracking = AfterShip::Tracking.new(data)
      expect(tracking.order_id_path).to eq('???')
    end

    it 'origin_country_iso3' do
      data     = { origin_country_iso3: 'IND' }
      tracking = AfterShip::Tracking.new(data)
      expect(tracking.origin_country_iso3).to eq('IND')
    end

    it 'unique_token' do
      data     = { unique_token: 'bk6ysTW1U' }
      tracking = AfterShip::Tracking.new(data)
      expect(tracking.unique_token).to eq('bk6ysTW1U')
    end

    it 'shipment_package_count' do
      data     = { shipment_package_count: 1 }
      tracking = AfterShip::Tracking.new(data)
      expect(tracking.shipment_package_count).to eq(1)
    end

    it 'shipment_type' do
      data     = { shipment_type: 'UPS SAVER' }
      tracking = AfterShip::Tracking.new(data)
      expect(tracking.shipment_type).to eq('UPS SAVER')
    end

    it 'shipment_weight' do
      data     = { shipment_weight: 1 }
      tracking = AfterShip::Tracking.new(data)
      expect(tracking.shipment_weight).to eq(1)
    end

    it 'shipment_weight_unit' do
      data     = { shipment_weight_unit: 'kg' }
      tracking = AfterShip::Tracking.new(data)
      expect(tracking.shipment_weight_unit).to eq('kg')
    end

    it 'signed_by' do
      data     = { signed_by: 'A GUPTA (OFFICE)' }
      tracking = AfterShip::Tracking.new(data)
      expect(tracking.signed_by).to eq('A GUPTA (OFFICE)')
    end

    it 'smses' do
      data     = { smses: [] }
      tracking = AfterShip::Tracking.new(data)
      expect(tracking.smses).to eq([])
    end

    it 'source' do
      data     = { source: 'api' }
      tracking = AfterShip::Tracking.new(data)
      expect(tracking.source).to eq('api')
    end

    it 'tag' do
      data     = { tag: 'Delivered' }
      tracking = AfterShip::Tracking.new(data)
      expect(tracking.tag).to eq('Delivered')
    end

    it 'status' do
      data     = { tag: 'Delivered' }
      tracking = AfterShip::Tracking.new(data)
      expect(tracking.status).to eq('Delivered')
    end

    it 'title' do
      data     = { title: '1ZA2207X0444990982' }
      tracking = AfterShip::Tracking.new(data)
      expect(tracking.title).to eq('1ZA2207X0444990982')
    end

    it 'tracked_count' do
      data     = { tracked_count: 3 }
      tracking = AfterShip::Tracking.new(data)
      expect(tracking.tracked_count).to eq(3)
    end

    it 'checkpoints' do
      data     = {
        checkpoints: [
          {
            slug: 'ups'
          }
        ]
      }
      tracking = AfterShip::Tracking.new(data)
      expect(tracking.checkpoints.size).to eq(1)
    end
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

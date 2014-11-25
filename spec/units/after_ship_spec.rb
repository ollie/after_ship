require 'spec_helper'

RSpec.describe AfterShip do
  it 'fails to make a client' do
    expect { AfterShip.new }.to raise_error
  end

  context 'With api_key' do
    let(:client) { AfterShip.new(api_key: 'key') }

    it 'api_key' do
      expect(client.api_key).to eq('key')
    end

    it 'debug' do
      AfterShip.debug = true
      expect(AfterShip.debug).to eq(true)
      AfterShip.debug = nil
    end

    it 'trackings' do
      allow(AfterShip::Request).to receive(:get).and_yield(
        data: {
          trackings: [
            {
              slug: 'ups'
            }
          ]
        }
      )

      trackings = client.trackings
      expect(trackings.size).to eq(1)
    end

    it 'tracking' do
      allow(AfterShip::Request).to receive(:get).and_yield(
        data: {
          tracking: {
            slug: 'ups'
          }
        }
      )

      tracking = client.tracking('tracking-number', 'ups')
      expect(tracking.slug).to eq('ups')
    end

    it 'create_tracking' do
      allow(AfterShip::Request).to receive(:post).and_yield(
        data: {
          tracking: {
            slug:     'ups',
            order_id: 'order-id'
          }
        }
      )

      tracking = client.create_tracking(
        'tracking-number',
        'ups',
        order_id: 'order-id'
      )

      expect(tracking.slug).to eq('ups')
      expect(tracking.order_id).to eq('order-id')
    end

    it 'update_tracking' do
      allow(AfterShip::Request).to receive(:put).and_yield(
        data: {
          tracking: {
            slug:     'ups',
            order_id: 'order-id'
          }
        }
      )

      tracking = client.update_tracking(
        'tracking-number',
        'ups',
        order_id: 'order-id'
      )

      expect(tracking.slug).to eq('ups')
      expect(tracking.order_id).to eq('order-id')
    end

    it 'couriers' do
      allow(AfterShip::Request).to receive(:get).and_yield(
        data: {
          couriers: [
            {
              slug: 'ups'
            }
          ]
        }
      )

      couriers = client.couriers
      expect(couriers.size).to eq(1)
    end
  end
end

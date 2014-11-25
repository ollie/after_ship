require 'spec_helper'

RSpec.describe AfterShip::Courier do
  context 'Attributes' do
    it 'slug' do
      data     = { slug: 'ups' }
      tracking = AfterShip::Courier.new(data)
      expect(tracking.slug).to eq('ups')
    end

    it 'name' do
      data     = { name: 'UPS' }
      tracking = AfterShip::Courier.new(data)
      expect(tracking.name).to eq('UPS')
    end

    it 'phone' do
      data     = { phone: '+1 800 742 5877' }
      tracking = AfterShip::Courier.new(data)
      expect(tracking.phone).to eq('+1 800 742 5877')
    end

    it 'other_name' do
      data     = { other_name: 'United Parcel Service' }
      tracking = AfterShip::Courier.new(data)
      expect(tracking.other_name).to eq('United Parcel Service')
    end

    it 'web_url' do
      data     = { web_url: 'http://www.ups.com' }
      tracking = AfterShip::Courier.new(data)
      expect(tracking.web_url).to eq('http://www.ups.com')
    end

    it 'required_fields' do
      data     = { required_fields: [] }
      tracking = AfterShip::Courier.new(data)
      expect(tracking.required_fields).to eq([])
    end
  end
end

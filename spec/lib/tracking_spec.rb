require 'spec_helper'

RSpec.describe AfterShip::Tracking do
  before do
    @client = AfterShip.new(api_key: 'key')
  end

  it 'tracking returns Tracking instance' do
    tracking = @client.tracking('real', 'ups')
    expect(tracking).to be_a(AfterShip::Tracking)
  end

  context 'expected_delivery' do
    it 'nil' do
      date     = nil
      tracking = AfterShip::Tracking.new(tracking: { expected_delivery: date })
      expect(tracking.expected_delivery).to be_nil
    end

    it 'YYYY-MM-DD' do
      date     = '2014-07-29'
      tracking = AfterShip::Tracking.new(tracking: { expected_delivery: date })
      expected = Date.parse('2014-07-29')
      expect(tracking.expected_delivery).to eq(expected)
    end

    it 'YYYY-MM-DDTHH:MM:SS' do
      date     = '2014-07-29T16:08:23'
      tracking = AfterShip::Tracking.new(tracking: { expected_delivery: date })
      expected = DateTime.parse('2014-07-29T16:08:23')
      expect(tracking.expected_delivery).to eq(expected)
    end

    it 'YYYY-MM-DDTHH:MM:SSZ' do
      date     = '2014-07-29T16:08:23Z'
      tracking = AfterShip::Tracking.new(tracking: { expected_delivery: date })
      expected = DateTime.parse('2014-07-29T16:08:23Z')
      expect(tracking.expected_delivery).to eq(expected)
    end

    it 'YYYY-MM-DDTHH:MM:SS+HH:MM' do
      date     = '2014-07-29T16:08:23+02:00'
      tracking = AfterShip::Tracking.new(tracking: { expected_delivery: date })
      expected = DateTime.parse('2014-07-29T16:08:23+02:00')
      expect(tracking.expected_delivery).to eq(expected)
    end

    it 'YYYY-MM-DDTHH:MM:SS-HH:MM' do
      date     = '2014-07-29T16:08:23-02:00'
      tracking = AfterShip::Tracking.new(tracking: { expected_delivery: date })
      expected = DateTime.parse('2014-07-29T16:08:23-02:00')
      expect(tracking.expected_delivery).to eq(expected)
    end

    it 'everything else raises an error' do
      expect do
        date     = 'xxx'
        AfterShip::Tracking.new(tracking: { expected_delivery: date })
      end.to raise_error(ArgumentError)
    end
  end
end

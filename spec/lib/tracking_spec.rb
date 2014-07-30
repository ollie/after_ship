require 'spec_helper'

RSpec.describe AfterShip::Tracking do
  before do
    @client = AfterShip.new(api_key: 'key')
  end

  it 'tracking returns Tracking instance' do
    tracking = @client.tracking('real', 'ups')
    expect(tracking).to be_a(AfterShip::Tracking)
    expect(tracking.checkpoints.size).to eq(41)
  end
end

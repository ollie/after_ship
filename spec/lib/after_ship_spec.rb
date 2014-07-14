require 'spec_helper'

RSpec.describe AfterShip do
  it 'fails to make a client' do
    expect { AfterShip.new }.to raise_error
  end

  context 'With api_key' do
    before do
      @client = AfterShip.new(api_key: 'key')
    end

    it 'api_key' do
      expect(@client.api_key).to eq('key')
    end

    context 'require_arguments' do
      it 'tracking_number: nil raises error' do
        expect { @client.require_arguments tracking_number: nil }
          .to raise_error(ArgumentError)
      end

      it "tracking_number: 1, courier: '' raises error" do
        expect { @client.require_arguments tracking_number: 1, courier: '' }
          .to raise_error(ArgumentError)
      end

      it "tracking_number: 'abc', courier: 'def' does not raise error" do
        options = { tracking_number: 'abc', courier: 'def' }
        expect { @client.require_arguments(options) }
          .to_not raise_error
      end
    end

    context 'trackings' do
      it 'response 200' do
        expect { @client.trackings }
          .to_not raise_error
      end
    end

    context 'tracking' do
      it 'response 200' do
        expect { @client.tracking('ABC123', 'ups') }
          .to_not raise_error
      end

      it 'response 201' do
        expect { @client.tracking('201', 'ups') }
          .to_not raise_error
      end

      it 'response 400' do
        expect { @client.tracking('400', 'ups') }
          .to raise_error(AfterShip::InvalidJSONDataError)
      end

      it 'response 401' do
        expect { @client.tracking('401', 'ups') }
          .to raise_error(AfterShip::InvalidCredentialsError)
      end

      it 'response 402' do
        expect { @client.tracking('402', 'ups') }
          .to raise_error(AfterShip::RequestFailedError)
      end

      it 'response 404' do
        expect { @client.tracking('404', 'ups') }
          .to raise_error(AfterShip::ResourceNotFoundError)
      end

      it 'response 409' do
        expect { @client.tracking('409', 'ups') }
          .to raise_error(AfterShip::InvalidArgumentError)
      end

      it 'response 429' do
        expect { @client.tracking('429', 'ups') }
          .to raise_error(AfterShip::TooManyRequestsError)
      end

      it 'response 500' do
        expect { @client.tracking('500', 'ups') }
          .to raise_error(AfterShip::ServerError)
      end

      it 'response 502' do
        expect { @client.tracking('502', 'ups') }
          .to raise_error(AfterShip::ServerError)
      end

      it 'response 503' do
        expect { @client.tracking('503', 'ups') }
          .to raise_error(AfterShip::ServerError)
      end

      it 'response 504' do
        expect { @client.tracking('504', 'ups') }
          .to raise_error(AfterShip::ServerError)
      end

      it 'response 666' do
        expect { @client.tracking('666', 'ups') }
          .to raise_error(AfterShip::UnknownError)
      end
    end

    context 'create_tracking' do
      it 'response 200' do
        expect { @client.create_tracking('ABC123', 'ups') }
          .to_not raise_error
      end

      it 'with options response 200' do
        expect { @client.create_tracking('ABC123', 'ups', order_id: '1234') }
          .to_not raise_error
      end
    end

    context 'update_tracking' do
      it 'response 200' do
        expect { @client.update_tracking('ABC123', 'ups', order_id: '1234') }
          .to_not raise_error
      end
    end
  end
end

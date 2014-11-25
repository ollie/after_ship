require 'spec_helper'

RSpec.describe AfterShip::ErrorHandler do
  it 'precheck' do
    response = double('Typhoeus Response')
    allow(response).to receive(:timed_out?).and_return(false)
    expect { AfterShip::ErrorHandler.precheck(response) }
      .to_not raise_error
  end

  it 'precheck with timeout raises an error' do
    response = double('Typhoeus Response')
    allow(response).to receive(:timed_out?).and_return(true)
    allow(response).to receive(:effective_url).and_return('test-url')
    expect { AfterShip::ErrorHandler.precheck(response) }
      .to raise_error(AfterShip::Error::Timeout)
  end

  it 'check with missing code raises an error' do
    meta = {}
    expect { AfterShip::ErrorHandler.check(meta) }
      .to raise_error(KeyError)
  end

  it 'check with success code' do
    meta = { code: 200 }
    expect { AfterShip::ErrorHandler.check(meta) }
      .to_not raise_error
  end

  it 'check with error code' do
    meta = { code: 400 }
    expect { AfterShip::ErrorHandler.check(meta) }
      .to raise_error(AfterShip::Error::BadRequest)
  end

  context 'error_class_for' do
    it '400' do
      expect(AfterShip::ErrorHandler.error_class_for(400))
        .to eq(AfterShip::Error::BadRequest)
    end

    it '4001' do
      expect(AfterShip::ErrorHandler.error_class_for(4001))
        .to eq(AfterShip::Error::InvalidJsonData)
    end

    it '4002' do
      expect(AfterShip::ErrorHandler.error_class_for(4002))
        .to eq(AfterShip::Error::InvalidJsonData)
    end

    it '4003' do
      expect(AfterShip::ErrorHandler.error_class_for(4003))
        .to eq(AfterShip::Error::TrackingAlreadyExists)
    end

    it '4004' do
      expect(AfterShip::ErrorHandler.error_class_for(4004))
        .to eq(AfterShip::Error::TrackingDoesNotExist)
    end

    it '4005' do
      expect(AfterShip::ErrorHandler.error_class_for(4005))
        .to eq(AfterShip::Error::TrackingNumberInvalid)
    end

    it '4006' do
      expect(AfterShip::ErrorHandler.error_class_for(4006))
        .to eq(AfterShip::Error::TrackingObjectRequired)
    end

    it '4007' do
      expect(AfterShip::ErrorHandler.error_class_for(4007))
        .to eq(AfterShip::Error::TrackingNumberRequired)
    end

    it '4008' do
      expect(AfterShip::ErrorHandler.error_class_for(4008))
        .to eq(AfterShip::Error::FieldInvalid)
    end

    it '4009' do
      expect(AfterShip::ErrorHandler.error_class_for(4009))
        .to eq(AfterShip::Error::FieldRequired)
    end

    it '4010' do
      expect(AfterShip::ErrorHandler.error_class_for(4010))
        .to eq(AfterShip::Error::SlugInvalid)
    end

    it '4011' do
      expect(AfterShip::ErrorHandler.error_class_for(4011))
        .to eq(AfterShip::Error::CourierFieldInvalid)
    end

    it '4012' do
      expect(AfterShip::ErrorHandler.error_class_for(4012))
        .to eq(AfterShip::Error::CourierNotDetected)
    end

    it '4013' do
      expect(AfterShip::ErrorHandler.error_class_for(4013))
        .to eq(AfterShip::Error::RetrackNotAllowed)
    end

    it '4016' do
      expect(AfterShip::ErrorHandler.error_class_for(4016))
        .to eq(AfterShip::Error::RetrackNotAllowed)
    end

    it '4014' do
      expect(AfterShip::ErrorHandler.error_class_for(4014))
        .to eq(AfterShip::Error::NotificationRequired)
    end

    it '4015' do
      expect(AfterShip::ErrorHandler.error_class_for(4015))
        .to eq(AfterShip::Error::IdInvalid)
    end

    it '401' do
      expect(AfterShip::ErrorHandler.error_class_for(401))
        .to eq(AfterShip::Error::Unauthorized)
    end

    it '403' do
      expect(AfterShip::ErrorHandler.error_class_for(403))
        .to eq(AfterShip::Error::Forbidden)
    end

    it '404' do
      expect(AfterShip::ErrorHandler.error_class_for(404))
        .to eq(AfterShip::Error::NotFound)
    end

    it '429' do
      expect(AfterShip::ErrorHandler.error_class_for(429))
        .to eq(AfterShip::Error::TooManyRequests)
    end

    it '500' do
      expect(AfterShip::ErrorHandler.error_class_for(500))
        .to eq(AfterShip::Error::InternalError)
    end

    it '502' do
      expect(AfterShip::ErrorHandler.error_class_for(502))
        .to eq(AfterShip::Error::InternalError)
    end

    it '503' do
      expect(AfterShip::ErrorHandler.error_class_for(503))
        .to eq(AfterShip::Error::InternalError)
    end

    it '504' do
      expect(AfterShip::ErrorHandler.error_class_for(504))
        .to eq(AfterShip::Error::InternalError)
    end

    it '666' do
      expect(AfterShip::ErrorHandler.error_class_for(666))
        .to eq(AfterShip::Error::UnknownError)
    end
  end
end

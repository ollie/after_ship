require 'spec_helper'

RSpec.describe AfterShip::Request do
  let(:response_401) do
    '
      {
        "meta": {
          "code": 401,
          "message": "Invalid API Key.",
          "type": "Unauthorized"
        },
        "data": {}
      }
    '
  end

  let(:response_200) do
    '
      {
        "meta": {
          "code": 200
        },
        "data": {
          "tracking": {
            "slug": "ups"
          }
        }
      }
    '
  end

  let(:typhoeus_response_timeout) do
    typhoeus_response = double('Typhoeus response')
    allow(typhoeus_response).to receive(:timed_out?).and_return(true)
    allow(typhoeus_response).to receive(:effective_url)
      .and_return('http://bla.bla/')
    typhoeus_response
  end

  let(:typhoeus_response_401) do
    typhoeus_response = double('Typhoeus response')
    allow(typhoeus_response).to receive(:timed_out?).and_return(false)
    allow(typhoeus_response).to receive(:body).and_return(response_401)
    typhoeus_response
  end

  let(:typhoeus_response_200) do
    typhoeus_response = double('Typhoeus response')
    allow(typhoeus_response).to receive(:timed_out?).and_return(false)
    allow(typhoeus_response).to receive(:body).and_return(response_200)
    typhoeus_response
  end

  it 'initialize with missing :api_key raises an error' do
    expect { AfterShip::Request.new(url: 'http://bla.bla/', method: :get) }
      .to raise_error(KeyError).with_message('key not found: :api_key')
  end

  it 'initialize with missing :url raises an error' do
    expect { AfterShip::Request.new(api_key: 'key', method: :get) }
      .to raise_error(KeyError).with_message('key not found: :url')
  end

  it 'initialize with missing :method raises an error' do
    expect { AfterShip::Request.new(api_key: 'key', url: 'http://bla.bla/') }
      .to raise_error(KeyError).with_message('key not found: :method')
  end

  it 'get' do
    allow_any_instance_of(AfterShip::Request)
      .to receive(:typhoeus_response).and_return(typhoeus_response_200)

    args     = { api_key: 'key', url: 'http://bla.bla/' }
    response = AfterShip::Request.get(args)
    expected = {
      meta: {
        code: 200
      },
      data: {
        tracking: {
          slug: 'ups'
        }
      }
    }

    expect(response).to eq(expected)
  end

  it 'post' do
    allow_any_instance_of(AfterShip::Request)
      .to receive(:typhoeus_response).and_return(typhoeus_response_200)

    args     = { api_key: 'key', url: 'http://bla.bla/' }
    response = AfterShip::Request.post(args)
    expected = {
      meta: {
        code: 200
      },
      data: {
        tracking: {
          slug: 'ups'
        }
      }
    }

    expect(response).to eq(expected)
  end

  it 'put' do
    allow_any_instance_of(AfterShip::Request)
      .to receive(:typhoeus_response).and_return(typhoeus_response_200)

    args     = { api_key: 'key', url: 'http://bla.bla/' }
    response = AfterShip::Request.put(args)
    expected = {
      meta: {
        code: 200
      },
      data: {
        tracking: {
          slug: 'ups'
        }
      }
    }

    expect(response).to eq(expected)
  end

  it 'response raises an error on timeout' do
    allow_any_instance_of(AfterShip::Request)
      .to receive(:typhoeus_response).and_return(typhoeus_response_timeout)

    args    = { api_key: 'key', url: 'http://bla.bla/', method: :get }
    request = AfterShip::Request.new(args)

    expect { request.response }.to raise_error(AfterShip::Error::Timeout)
  end

  it 'response loads data and raises an error' do
    allow_any_instance_of(AfterShip::Request)
      .to receive(:typhoeus_response).and_return(typhoeus_response_401)

    args    = { api_key: 'key', url: 'http://bla.bla/', method: :get }
    request = AfterShip::Request.new(args)

    expect { request.response }.to raise_error(AfterShip::Error::Unauthorized)
  end

  it 'response without a block' do
    allow_any_instance_of(AfterShip::Request)
      .to receive(:typhoeus_response).and_return(typhoeus_response_200)

    args     = { api_key: 'key', url: 'http://bla.bla/', method: :get }
    request  = AfterShip::Request.new(args)
    expected = {
      meta: {
        code: 200
      },
      data: {
        tracking: {
          slug: 'ups'
        }
      }
    }

    expect(request.response).to eq(expected)
  end

  it 'response with a block' do
    allow_any_instance_of(AfterShip::Request)
      .to receive(:typhoeus_response).and_return(typhoeus_response_200)

    args     = { api_key: 'key', url: 'http://bla.bla/', method: :get }
    request  = AfterShip::Request.new(args) do |response|
      response[:data][:tracking]
    end
    expected = {
      slug: 'ups'
    }

    expect(request.response).to eq(expected)
  end

  it 'typhoeus_response' do
    allow_any_instance_of(Typhoeus::Request).to receive(:run)
    args     = { api_key: 'key', url: 'http://bla.bla/', method: :get }
    request  = AfterShip::Request.new(args)
    expect { request.send(:typhoeus_response) }.to_not raise_error
  end
end

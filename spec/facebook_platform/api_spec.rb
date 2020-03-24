# frozen_string_literal: true

require 'facebook_platform/api'

RSpec.describe FacebookPlatform::API do
  context '.base_url' do
    it 'returns default facebook API url' do
      expect(described_class.base_url).to eq('https://graph.facebook.com')
    end
  end

  context '.version' do
    it 'returns default facebook API version' do
      expect(described_class.version).to eq('v5.0')
    end

    it 'returns facebook API version from ENV' do
      expect(ENV).to receive(:[]).with('FACEBOOK_API_VERSION').and_return('v4.1')
      expect(described_class.version).to eq('v4.1')
    end
  end

  context '.api_url' do
    it 'returns facebook API url with default path' do
      expect(described_class.api_url).to eq('https://graph.facebook.com/v5.0/')
    end

    it 'returns facebook API url with provided path' do
      expect(described_class.api_url('123/system_users')).to eq('https://graph.facebook.com/v5.0/123/system_users')
    end
  end

  context '.get' do
    it 'invokes .request with params' do
      expect(described_class).to receive(:request).with(:get, 'me/businesses', access_token: '123')
      described_class.get('me/businesses', access_token: '123')
    end
  end

  context '.post' do
    it 'invokes .request with params' do
      expect(described_class).to receive(:request).with(:post, 'me/businesses', access_token: '123')
      described_class.post('me/businesses', access_token: '123')
    end
  end

  context '.delete' do
    it 'invokes .request with params' do
      expect(described_class).to receive(:request).with(:delete, 'me/businesses', access_token: '123')
      described_class.delete('me/businesses', access_token: '123')
    end
  end

  context '.request' do
    let(:success_response) { double 'Success Response', body: '{"data":{}}' }
    let(:error_response) { double 'Error Response', body: '{"error":{"message": "Facebook API error message"}}' }

    it 'invokes Faraday client with params and returns json' do
      expect(Faraday).to receive(:send).with(
        :get, 'https://graph.facebook.com/v5.0/me/businesses', access_token: '123'
      ).and_return(success_response)
      described_class.request(:get, 'me/businesses', access_token: '123')
    end

    it 'raises an exception if json returns an error response' do
      expect do
        expect(Faraday).to receive(:send).with(
          :get, 'https://graph.facebook.com/v5.0/me/businesses', access_token: '123'
        ).and_return(error_response)
        described_class.request(:get, 'me/businesses', access_token: '123')
      end.to raise_error(FacebookPlatform::API::Error, 'Facebook API error message')
    end
  end
end

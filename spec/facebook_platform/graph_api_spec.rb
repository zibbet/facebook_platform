require 'facebook_platform/graph_api'

RSpec.describe FacebookPlatform::GraphAPI do
  let(:api_client) { double 'Koala::Facebook::API' }

  context '.initialize' do
    it 'invokes Koala::Facebook::API' do
      expect(Koala::Facebook::API).to receive(:new).with(access_token: 'ACCESS_TOKEN_123')
      described_class.new(access_token: 'ACCESS_TOKEN_123')
    end

    it 'creates Koala getter' do
      expect(Koala::Facebook::API).to receive(:new).and_return(api_client)
      client = described_class.new(access_token: 'ACCESS_TOKEN_123')
      expect(client.graph_api).to eq(api_client)
    end
  end

  context '#connections' do
    it 'invokes Koala get_connections method' do
      expect_any_instance_of(Koala::Facebook::API).to receive(:get_connections).with('id', 'name')
      client = described_class.new(access_token: 'ACCESS_TOKEN_123')
      client.connections(id: 'id', name: 'name')
    end
  end

  context '#create_connection' do
    it 'invokes Koala put_connections method with default params' do
      expect_any_instance_of(Koala::Facebook::API).to receive(:put_connections).with('id', 'name', {})
      client = described_class.new(access_token: 'ACCESS_TOKEN_123')
      client.create_connection(id: 'id', name: 'name')
    end

    it 'invokes Koala put_connections method with default params' do
      expect_any_instance_of(Koala::Facebook::API).to receive(:put_connections).with('id', 'name', role: 'ADMIN')
      client = described_class.new(access_token: 'ACCESS_TOKEN_123')
      client.create_connection(id: 'id', name: 'name', params: { role: 'ADMIN' })
    end
  end
end

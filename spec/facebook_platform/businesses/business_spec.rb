require 'facebook_platform/api'
require 'facebook_platform/businesses/business'

RSpec.describe FacebookPlatform::Businesses::Business do
  context '.new' do
    it 'creates an instance and getters' do
      business = described_class.new(id: 123, name: 'Death Star')
      expect(business.id).to eq(123)
      expect(business.name).to eq('Death Star')
    end
  end

  context '.all' do
    it 'returns an objects array created from a request results hash' do
      expect(FacebookPlatform::API).to receive(:get).with(
        'me/businesses', access_token: 'ABC-123'
      ).and_return('data' => [{ 'id' => '1', 'name' => 'Death Star' }])
      result = described_class.all(access_token: 'ABC-123')
      expect(result.first).to have_attributes(id: '1', name: 'Death Star')
    end
  end
end

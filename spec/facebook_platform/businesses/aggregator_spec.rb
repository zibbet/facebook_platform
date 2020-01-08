# frozen_string_literal: true

require 'facebook_platform/api'
require 'facebook_platform/businesses/aggregator'

RSpec.describe FacebookPlatform::Businesses::Aggregator do
  context '.create' do
    it 'returns a business id' do
      expect(FacebookPlatform::API).to receive(:post).with(
        '123/managed_businesses',
        access_token: 'ABC-123',
        existing_client_business_id: '456'
      ).and_return('id' => '456')
      result = described_class.create(access_token: 'ABC-123', partner_business_id: '123', client_business_id: '456')
      expect(result).to eq('id' => '456')
    end
  end

  context '.get_client_system_user_token' do
    it 'returns a access token' do
      expect(FacebookPlatform::API).to receive(:post).with(
        '456/access_token',
        access_token: 'ABC-123',
        app_id: '123',
        scope: 'ads_management,manage_pages'
      ).and_return('access_token' => '123FABC1231237567')
      result = described_class.get_client_system_user_token(
        access_token: 'ABC-123',
        business_id: '456',
        app_id: '123'
      )
      expect(result).to eq('123FABC1231237567')
    end
  end
end

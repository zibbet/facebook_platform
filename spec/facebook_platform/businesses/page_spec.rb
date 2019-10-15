# frozen_string_literal: true

require 'facebook_platform/api'
require 'facebook_platform/businesses/page'

RSpec.describe FacebookPlatform::Businesses::Page do
  context '.new' do
    it 'creates an instance and getters' do
      page = described_class.new(id: 123, name: 'Death Star')
      expect(page.id).to eq(123)
      expect(page.name).to eq('Death Star')
    end
  end

  context '.all' do
    it 'returns an objects array created from a request results hash' do
      expect(FacebookPlatform::API).to receive(:get).with(
        '1234567/owned_pages', access_token: 'ABC-123'
      ).and_return('data' => [{ 'id' => '1', 'name' => 'Death Star', 'access_token' => 'ABC-123' }])
      result = described_class.all(business_id: 1_234_567, access_token: 'ABC-123')
      expect(result.first).to have_attributes(id: '1', name: 'Death Star')
    end
  end
end

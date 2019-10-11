# frozen_string_literal: true

require 'facebook_platform/api'
require 'facebook_platform/products/catalog'

RSpec.describe FacebookPlatform::Products::Catalog do
  context '.new' do
    it 'creates an instance and getters' do
      catalog = described_class.new(id: 123, name: 'Death star')
      expect(catalog.id).to eq(123)
      expect(catalog.name).to eq('Death star')
    end
  end

  context '.create' do
    it 'returns a created object serialized from hash' do
      expect(FacebookPlatform::API).to receive(:post).with(
        '123/owned_product_catalogs',
        access_token: 'ABC-123',
        name: 'Death Star'
      ).and_return('id' => '100041623866064')
      result = described_class.create(access_token: 'ABC-123', business_id: '123', name: 'Death Star')
      expect(result).to have_attributes(id: '100041623866064', name: 'Death Star')
    end
  end
end

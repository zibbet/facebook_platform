# frozen_string_literal: true

require 'facebook_platform/api'
require 'facebook_platform/products/product'

RSpec.describe FacebookPlatform::Products::Product do
  context '.exists_in_catalog?' do
    it 'returns true if a product was found by retailed_id in a catalog' do
      expect(FacebookPlatform::API).to receive(:get).with(
        '12345/products',
        access_token: 'ABC-123',
        filter: { retailer_id: { eq: 432 } },
        summary: true
      ).and_return('summary' => { 'total_count' => 1 })
      result = described_class.exists_in_catalog?(access_token: 'ABC-123', catalog_id: '12345', retailer_id: 432)
      expect(result).to be_truthy
    end

    it 'returns false if a product was not found by retailed_id in a catalog' do
      expect(FacebookPlatform::API).to receive(:get).with(
        '12345/products',
        access_token: 'ABC-123',
        filter: { retailer_id: { eq: 432 } },
        summary: true
      ).and_return('summary' => { 'total_count' => 0 })
      result = described_class.exists_in_catalog?(access_token: 'ABC-123', catalog_id: '12345', retailer_id: 432)
      expect(result).to be_falsey
    end
  end

  context '.delete_all' do
    it 'returns a hash on success' do
      expect(FacebookPlatform::API).to receive(:post).with(
        '12345/items_batch',
        access_token: 'ABC-123',
        item_type: 'PRODUCT_ITEM',
        requests: [{ method: 'DELETE', data: { id: '432' } }].to_json
      ).and_return('handles' => ['AczwaOW7j_'])
      result = described_class.delete_all(access_token: 'ABC-123', catalog_id: '12345', retailer_ids: [432])
      expect(result).to eq('handles' => ['AczwaOW7j_'])
    end
  end
end

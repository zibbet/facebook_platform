# frozen_string_literal: true

require 'facebook_platform/api'
require 'facebook_platform/products/product'

RSpec.describe FacebookPlatform::Products::Product do
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

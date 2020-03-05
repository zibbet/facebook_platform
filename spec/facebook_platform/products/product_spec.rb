# frozen_string_literal: true

require 'facebook_platform/api'
require 'facebook_platform/products/product'

RSpec.describe FacebookPlatform::Products::Product do
  context '#new' do
    it 'returns a Product instance' do
      result = described_class.new(id: '3385594441457124', name: 'Test Red Shirt', retailer_id: '15876_variant_id_7499')
      expect(result.id).to eq('3385594441457124')
      expect(result.name).to eq('Test Red Shirt')
      expect(result.retailer_id).to eq('15876_variant_id_7499')
    end
  end

  context '.find_by_retailer_id' do
    it 'returns a Product instance if found' do
      expect(FacebookPlatform::API).to receive(:get).with(
        '12345/products',
        access_token: 'ABC-123',
        filter: '{"retailer_id":{"eq":"432_bla"}}'
      ).and_return(
        {
          'data' =>
            [
              {
                'id' => '3385594441457124',
                'name' => 'Test Red Shirt',
                'retailer_id' => '15876_variant_id_7499'
              }
            ]
        }
      )
      result = described_class.find_by_retailer_id(access_token: 'ABC-123', catalog_id: '12345', retailer_id: '432_bla')
      expect(result.id).to eq('3385594441457124')
      expect(result.name).to eq('Test Red Shirt')
      expect(result.retailer_id).to eq('15876_variant_id_7499')
    end

    it 'returns nil if not found' do
      expect(FacebookPlatform::API).to receive(:get).with(
        '12345/products',
        access_token: 'ABC-123',
        filter: '{"retailer_id":{"eq":"432"}}'
      ).and_return(
        {
          'data' => []
        }
      )
      result = described_class.find_by_retailer_id(access_token: 'ABC-123', catalog_id: '12345', retailer_id: 432)
      expect(result).to be_nil
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

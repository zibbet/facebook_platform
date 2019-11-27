# frozen_string_literal: true

require 'facebook_platform/api'
require 'facebook_platform/products/feed'

RSpec.describe FacebookPlatform::Products::Feed do
  context '.new' do
    it 'creates an instance and getters' do
      catalog = described_class.new(id: 123)
      expect(catalog.id).to eq(123)
    end
  end

  context '.create' do
    it 'returns a created object serialized from hash with custom options' do
      expect(FacebookPlatform::API).to receive(:post).with(
        '999022/product_feeds',
        access_token: 'ABC-123',
        name: 'Death Star',
        schedule: {
          interval: 'DAILY',
          url: 'https://www.zibbet.com/path/to/upload_products.csv',
          hour: 23
        }
      ).and_return('id' => '100041623866064')
      result = described_class.create(
        access_token: 'ABC-123',
        catalog_id: '999022',
        name: 'Death Star',
        products_csv_url: 'https://www.zibbet.com/path/to/upload_products.csv',
        interval: 'DAILY',
        options: { hour: 23 }
      )
      expect(result).to have_attributes(id: '100041623866064')
    end

    it 'returns a created object serialized from hash with default options' do
      expect(FacebookPlatform::API).to receive(:post).with(
        '999022/product_feeds',
        access_token: 'ABC-123',
        name: 'Death Star',
        schedule: {
          interval: 'HOURLY',
          url: 'https://www.zibbet.com/path/to/upload_products.csv'
        }
      ).and_return('id' => '100041623866064')
      result = described_class.create(
        access_token: 'ABC-123',
        catalog_id: '999022',
        name: 'Death Star',
        products_csv_url: 'https://www.zibbet.com/path/to/upload_products.csv'
      )
      expect(result).to have_attributes(id: '100041623866064')
    end
  end

  context '.update' do
    it 'returns true on success with custom options' do
      expect(FacebookPlatform::API).to receive(:post).with(
        '999022',
        access_token: 'ABC-123',
        update_schedule: {
          interval: 'DAILY',
          url: 'https://www.zibbet.com/path/to/upload_products.csv',
          hour: 23
        }
      ).and_return('success' => true)
      result = described_class.update(
        access_token: 'ABC-123',
        product_feed_id: '999022',
        products_csv_url: 'https://www.zibbet.com/path/to/upload_products.csv',
        interval: 'DAILY',
        options: { hour: 23 }
      )
      expect(result).to be_truthy
    end

    it 'returns true on success with default options' do
      expect(FacebookPlatform::API).to receive(:post).with(
        '999022',
        access_token: 'ABC-123',
        update_schedule: {
          interval: 'HOURLY',
          url: 'https://www.zibbet.com/path/to/upload_products.csv'
        }
      ).and_return('success' => true)
      result = described_class.update(
        access_token: 'ABC-123',
        product_feed_id: '999022',
        products_csv_url: 'https://www.zibbet.com/path/to/upload_products.csv'
      )
      expect(result).to be_truthy
    end
  end
end

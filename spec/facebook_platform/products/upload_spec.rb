# frozen_string_literal: true

require 'facebook_platform/api'
require 'facebook_platform/products/upload'

RSpec.describe FacebookPlatform::Products::Upload do
  context '.new' do
    it 'creates an instance and getters' do
      upload = described_class.new(id: 123)
      expect(upload.id).to eq(123)
    end
  end

  context '.all' do
    it 'returns an objects array created from a request results hash' do
      expect(FacebookPlatform::API).to receive(:get).with(
        '567/uploads', access_token: 'ABC-123'
      ).and_return('data' => [{ 'id' => '1' }])
      result = described_class.all(access_token: 'ABC-123', product_feed_id: 567)
      expect(result.first).to have_attributes(id: '1')
    end
  end

  describe '::Error' do
    context '.new' do
      it 'creates an instance and getters' do
        error = described_class::Error.new(
          id: 123,
          summary: 'summary',
          description: 'description',
          severity: 'fatal',
          samples: {}
        )
        expect(error.id).to eq(123)
        expect(error.summary).to eq('summary')
        expect(error.description).to eq('description')
        expect(error.severity).to eq('fatal')
        expect(error.samples).to eq({})
      end
    end

    context '.all' do
      let(:error_response) do
        {
          'data' => [
            {
              'id' => 123,
              'summary' => 'A required field is missing: price.',
              'description' => 'Products need to have prices to run in ads. Include a price for each product',
              'severity' => 'fatal',
              'samples' => {
                'data' => [
                  {
                    'row_number' => 2,
                    'retailer_id' => 'yj9bpbpub5t8t22kgbq6',
                    'id' => '1677559492523068'
                  },
                  {
                    'row_number' => 5,
                    'retailer_id' => 'ujn33tvbyv2vmdpo7ecb',
                    'id' => '1529743440653137'
                  }
                ]
              }
            }
          ]
        }
      end

      it 'returns an objects array created from a request results hash' do
        expect(FacebookPlatform::API).to receive(:get).with(
          '1/errors', access_token: 'ABC-123'
        ).and_return(error_response)
        results = described_class::Error.all(access_token: 'ABC-123', upload_id: 1)
        result = results.first
        data = error_response['data'].first
        expect(result).to have_attributes(id: data['id'],
                                          summary: data['summary'],
                                          description: data['description'],
                                          severity: data['severity'],
                                          samples: data['samples'])
      end
    end

    context '.create' do
      it 'returns a created object serialized from hash' do
        expect(FacebookPlatform::API).to receive(:post).with(
          '12345678/uploads',
          access_token: 'ABC-123',
          url: 'https://url_to_csv_file_to_upload.csv'
        ).and_return('id' => '100041623866064')
        result = described_class.create(
          access_token: 'ABC-123',
          product_feed_id: '12345678',
          products_csv_url: 'https://url_to_csv_file_to_upload.csv'
        )
        expect(result).to have_attributes(id: '100041623866064')
      end
    end
  end
end

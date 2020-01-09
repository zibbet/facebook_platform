# frozen_string_literal: true

require 'facebook_platform/api'
require 'facebook_platform/businesses/merchant_onboarding'

RSpec.describe FacebookPlatform::Businesses::MerchantOnboarding do
  context '.get_catalog_and_page_ids' do
    it 'returns a hash with page and catalog ids' do
      expect(FacebookPlatform::API).to receive(:get).with(
        '/1234567', access_token: 'ABC-123', fields: 'product_catalogs,merchant_page'
      ).and_return(
        'product_catalogs' => {
          'data' => [
            {
              'id' => '123',
              'name' => 'Catalog assigned during onboarding'
            }
          ]
        },
        'merchant_page' => {
          'id' => '866',
          'name' => 'Page assigned during onboarding'
        },
        'id' => '5544'
      )
      result = described_class.get_catalog_and_page_ids(access_token: 'ABC-123', cms_id: '1234567')
      expect(result).to eq(page_id: '866', catalog_id: '123')
    end
  end
end

# frozen_string_literal: true

module FacebookPlatform
  module Businesses
    # represents a data which was created during Merchant Onboarding flow on Facebook side
    class MerchantOnboarding
      def self.get_catalog_and_page_ids(access_token:, cms_id:)
        result = API.get("/#{cms_id}", access_token: access_token, fields: 'product_catalogs,merchant_page')
        { catalog_id: result['product_catalogs']['data'].last['id'], page_id: result['merchant_page']['id'] }
      end

      # https://developers.facebook.com/docs/commerce-platform/order-management/acknowledgement-api
      # The token here is PAGE_ACCESS_TOKEN
      def self.associate_order_management(access_token:, cms_id:)
        result = API.post("/#{cms_id}/order_management_apps", access_token: access_token)
        result['success']
      end
    end
  end
end

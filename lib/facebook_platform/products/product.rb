# frozen_string_literal: true

module FacebookPlatform
  module Products
    # represents Facebook's Catalog entity
    class Product
      # https://developers.facebook.com/docs/commerce-platform/catalog/batch-api
      def self.delete_all(access_token:, catalog_id:, retailer_ids:)
        requests = retailer_ids.map do |retailer_id|
          { method: 'DELETE', data: { id: retailer_id } }
        end
        API.post(
          "#{catalog_id}/items_batch",
          access_token: access_token,
          item_type: 'PRODUCT_ITEM',
          requests: requests.to_json
        )
      end
    end
  end
end

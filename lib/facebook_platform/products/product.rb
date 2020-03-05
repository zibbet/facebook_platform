# frozen_string_literal: true

module FacebookPlatform
  module Products
    # represents Facebook's product catalog entity
    class Product
      # https://developers.facebook.com/docs/marketing-api/reference/product-catalog/products/
      def self.exists_in_catalog?(access_token:, catalog_id:, retailer_id:)
        result = API.get(
          "#{catalog_id}/products",
          access_token: access_token,
          filter: { retailer_id: { eq: retailer_id } },
          summary: true
        )
        result.dig('summary', 'total_count') == 1
      end

      # https://developers.facebook.com/docs/commerce-platform/catalog/batch-api
      def self.delete_all(access_token:, catalog_id:, retailer_ids:)
        requests = retailer_ids.map do |retailer_id|
          { method: 'DELETE', data: { id: retailer_id.to_s } }
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

# frozen_string_literal: true

module FacebookPlatform
  module Products
    # represents Facebook's Catalog entity
    # https://developers.facebook.com/docs/marketing-api/reference/product-catalog/
    class Catalog
      attr_reader :id, :name

      def self.create(access_token:, business_id:, name: 'Zibbet')
        result = API.post("#{business_id}/owned_product_catalogs", access_token: access_token, name: name)
        new(id: result['id'], name: name)
      end

      def self.delete(access_token:, catalog_id:)
        result = API.delete(catalog_id, access_token: access_token)
        result['success']
      end

      def initialize(id:, name:)
        @id = id
        @name = name
      end
    end
  end
end

# frozen_string_literal: true

module FacebookPlatform
  module Products
    # represents Facebook's Catalog entity
    class Catalog
      attr_reader :id, :name

      def self.create(page_access_token:, business_id:, name: 'Zibbet')
        result = API.post("#{business_id}/owned_product_catalogs", access_token: page_access_token, name: name)
        new(id: result['id'], name: name)
      end

      def initialize(id:, name:)
        @id = id
        @name = name
      end
    end
  end
end

# frozen_string_literal: true

module FacebookPlatform
  module Products
    # represents Facebook's Product Feed entity
    class Feed
      attr_reader :id, :name

      def self.create(access_token:, catalog_id:, name:, products_csv_url:, interval: 'DAILY')
        result = API.post(
          "#{catalog_id}/product_feeds",
          access_token: access_token,
          name: name,
          schedule: { interval: interval, url: products_csv_url }
        )
        new(id: result['id'])
      end

      def initialize(id:)
        @id = id
      end
    end
  end
end

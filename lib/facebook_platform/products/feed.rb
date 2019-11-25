# frozen_string_literal: true

module FacebookPlatform
  module Products
    # represents Facebook's Product Feed entity
    class Feed
      attr_reader :id, :name

      # rubocop:disable  Metrics/ParameterLists
      def self.create(access_token:, catalog_id:, name:, products_csv_url:, interval: 'DAILY', hour: 23)
        result = API.post(
          "#{catalog_id}/product_feeds",
          access_token: access_token,
          name: name,
          schedule: { interval: interval, url: products_csv_url, hour: hour }
        )
        new(id: result['id'])
      end
      # rubocop:enable  Metrics/ParameterLists

      def self.update(access_token:, product_feed_id:, products_csv_url:, interval: 'DAILY', hour: 23)
        result = API.post(
          product_feed_id,
          access_token: access_token,
          update_schedule: { interval: interval, url: products_csv_url, hour: hour }
        )
        result['success']
      end

      def initialize(id:)
        @id = id
      end
    end
  end
end
# frozen_string_literal: true

module FacebookPlatform
  module Products
    # represents Facebook's Product Feed Upload entity
    class Upload
      attr_reader :id

      # represents Facebook's Upload Error entity
      class Error
        attr_reader :id, :summary, :description, :severity, :samples

        def initialize(id:, summary:, description:, severity:, samples:)
          @id = id
          @summary = summary
          @description = description
          @severity = severity
          @samples = samples
        end

        def self.all(access_token:, upload_id:)
          result = API.get("#{upload_id}/errors", access_token: access_token)
          result['data'].map do |hash|
            Error.new(
              id: hash['id'],
              summary: hash['summary'],
              description: hash['description'],
              severity: hash['severity'],
              samples: hash['samples']
            )
          end
        end
      end

      def self.all(access_token:, product_feed_id:)
        result = API.get("#{product_feed_id}/uploads", access_token: access_token)
        result['data'].map { |hash| new(id: hash['id']) }
      end

      #  One-Time Direct Upload
      def self.create(access_token:, product_feed_id:, products_csv_url:)
        result = API.post(
          "#{product_feed_id}/uploads",
          access_token: access_token,
          url: products_csv_url
        )
        new(id: result['id'])
      end

      def initialize(id:)
        @id = id
      end
    end
  end
end

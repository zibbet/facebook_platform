# frozen_string_literal: true

module FacebookPlatform
  module Orders
    # represents Facebook's Commerce Order Fulfillment API
    # https://developers.facebook.com/docs/commerce-platform/order-management/fulfillment-api/
    class Fulfillment
      # represents order items which needs to be shipped
      class Shipment
        attr_reader :retailer_id, :quantity

        def initialize(retailer_id:, quantity:)
          @retailer_id = retailer_id
          @quantity = quantity
        end

        def to_h
          { retailer_id: retailer_id, quantity: quantity }
        end
      end

      # represents shipping career details
      class TrackingInfo
        attr_reader :tracking_number, :carrier

        def initialize(tracking_number:, carrier:)
          @tracking_number = tracking_number
          @carrier = carrier
        end

        def to_h
          { tracking_number: tracking_number, carrier: carrier }
        end
      end

      # The token here is PAGE_ACCESS_TOKEN
      def self.create(order_id:, shipments:, tracking_info:, access_token:)
        result = API.post(
          "#{order_id}/shipments",
          access_token: access_token,
          items: shipments.map(&:to_h).to_json,
          tracking_info: tracking_info.to_h.to_json,
          idempotency_key: SecureRandom.uuid
        )
        result['success']
      end
    end
  end
end

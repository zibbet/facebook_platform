# frozen_string_literal: true

require 'securerandom'

module FacebookPlatform
  module Orders
    # represents Facebook's Order Acknowledgement
    # https://developers.facebook.com/docs/commerce-platform/order-management/acknowledgement-api
    class Acknowledgement
      attr_reader :order_id, :state, :error

      # The token here is PAGE_ACCESS_TOKEN
      def self.create(order_id:, access_token:)
        result = API.post(
          "#{order_id}/acknowledge_order",
          access_token: access_token,
          idempotency_key: SecureRandom.uuid
        )
        new(order_id: result['id'], state: result['state'], error: result['error'])
      end

      def initialize(order_id:, state:, error:)
        @order_id = order_id
        @state = state
        @error = error
      end
    end
  end
end

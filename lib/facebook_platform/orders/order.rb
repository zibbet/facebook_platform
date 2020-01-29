# frozen_string_literal: true

require 'bigdecimal'

module FacebookPlatform
  module Orders
    # represents Facebook's Commerce Platform Order entity
    class Order
      attr_reader :id,
                  :buyer_details,
                  :channel,
                  :state,
                  :currency_code,
                  :total_amount,
                  :total_tax_amount,
                  :items_total_amount,
                  :shipping_total_amount

      DEFAULT_FIELDS = %w[
        id
        buyer_details
        channel
        merchant_order_id
        order_status
        estimated_payment_details
      ].freeze

      # represents Facebook Order buyer details
      class BuyerDetails
        attr_reader :name, :email

        def initialize(name:, email:)
          @name = name
          @email = email
        end
      end

      def self.all(page_id:, access_token:, fields: DEFAULT_FIELDS.join(','))
        path = "#{page_id}/commerce_orders"
        result = API.get(path, access_token: access_token, fields: fields)
        orders = result['data'].map { |hash| new(hash) }
        orders << next_page_orders(path, result.dig('paging', 'next'))
        orders.flatten
      end

      def self.next_page_orders(path, next_page_url, orders = [])
        if next_page_url
          query_string = next_page_url.split('?')[1]
          result = API.get("#{path}?#{query_string}", {})
          orders << result['data'].map { |hash| new(hash) }
          next_page_orders(path, result.dig('paging', 'next'), orders)
        end
        orders
      end

      private_class_method :next_page_orders

      # rubocop:disable Metrics/MethodLength
      # rubocop:disable Metrics/AbcSize
      def initialize(properties)
        @id = properties['id']
        @buyer_details = BuyerDetails.new(
          name: properties.dig('buyer_details', 'name'),
          email: properties.dig('buyer_details', 'email')
        )
        @channel = properties['channel']
        @state = properties.dig('order_status', 'state')
        @currency_code = properties.dig('estimated_payment_details', 'total_amount', 'currency')
        @total_amount = BigDecimal(properties.dig('estimated_payment_details', 'total_amount', 'amount') || 0)
        @total_tax_amount = BigDecimal(properties.dig('estimated_payment_details', 'tax', 'amount') || 0)
        @items_total_amount = BigDecimal(
          properties.dig('estimated_payment_details', 'subtotal', 'items', 'amount') || 0
        )
        @shipping_total_amount = BigDecimal(
          properties.dig('estimated_payment_details', 'subtotal', 'shipping', 'amount') || 0
        )
      end
      # rubocop:enable Metrics/MethodLength
      # rubocop:enable Metrics/AbcSize
    end
  end
end

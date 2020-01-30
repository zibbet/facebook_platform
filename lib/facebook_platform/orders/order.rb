# frozen_string_literal: true

require 'bigdecimal'
require 'date'

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
                  :shipping_total_amount,
                  :shipping_address,
                  :created_at,
                  :updated_at,
                  :items

      DEFAULT_FIELDS = %w[
        id
        buyer_details
        channel
        merchant_order_id
        order_status
        estimated_payment_details
        created
        last_updated
        shipping_address
        items
      ].freeze

      # represents Facebook buyer_details object
      class BuyerDetails
        attr_reader :name, :email

        def initialize(name:, email:)
          @name = name
          @email = email
        end
      end

      # represents Facebook shipping_address object
      class ShippingAddress
        attr_reader :name, :street1, :street2, :city, :state_code, :postal_code, :country_code

        def initialize(properties)
          @name = properties['name']
          @street1 = properties['street1']
          @street2 = properties['street2']
          @city = properties['city']
          @state_code = properties['state']
          @postal_code = properties['postal_code']
          @country_code = properties['country']
        end
      end

      # represents Facebook item object
      class Item
        attr_reader :retailer_id, :quantity

        def initialize(retailer_id:, quantity:)
          @retailer_id = retailer_id
          @quantity = quantity
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
        @shipping_address = ShippingAddress.new(properties['shipping_address'])
        @created_at = DateTime.parse(properties['created'])
        @updated_at = DateTime.parse(properties['last_updated'])
        @items = properties['items'].map { |i| Item.new(retailer_id: i['retailer_id'], quantity: i['quantity']) }
      end
      # rubocop:enable Metrics/MethodLength
      # rubocop:enable Metrics/AbcSize
    end
  end
end

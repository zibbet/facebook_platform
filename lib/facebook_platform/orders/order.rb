# frozen_string_literal: true

module FacebookPlatform
  module Orders
    # represents Facebook's Commerce Platform Order entity
    class Order
      attr_reader :id, :buyer_details, :channel, :state

      # represents Facebook Order buyer details
      class BuyerDetails
        attr_reader :name, :email

        def initialize(name:, email:)
          @name = name
          @email = email
        end
      end

      def self.all(page_id:, access_token:, fields: 'id,buyer_details,channel,merchant_order_id,order_status')
        path = "#{page_id}/commerce_orders"
        result = API.get(path, access_token: access_token, fields: fields)
        orders = result['data'].map { |hash| build_new(hash) }
        orders << next_page_orders(path, result.dig('paging', 'next'))
        orders.flatten
      end

      def self.next_page_orders(path, next_page_url, orders = [])
        if next_page_url
          query_string = next_page_url.split('?')[1]
          result = API.get("#{path}?#{query_string}", {})
          orders << result['data'].map { |hash| build_new(hash) }
          next_page_orders(path, result.dig('paging', 'next'), orders)
        end
        orders
      end
      private_class_method :next_page_orders

      def self.build_new(hash)
        new(
          id: hash['id'],
          buyer_details: BuyerDetails.new(
            name: hash.dig('buyer_details', 'name'),
            email: hash.dig('buyer_details', 'email')
          ),
          channel: hash['channel'],
          state: hash.dig('order_status', 'state')
        )
      end
      private_class_method :build_new

      def initialize(id:, buyer_details:, channel:, state:)
        @id = id
        @buyer_details = buyer_details
        @channel = channel
        @state = state
      end
    end
  end
end

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

      # rubocop:disable Metrics/MethodLength:
      def self.all(page_id:, access_token:, fields: 'id,buyer_details,channel,merchant_order_id,order_status')
        # TODO: handle pagination
        result = API.get("#{page_id}/commerce_orders", access_token: access_token, fields: fields)
        result['data'].map do |hash|
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
      end
      # rubocop:enable Metrics/MethodLength:

      def initialize(id:, buyer_details:, channel:, state:)
        @id = id
        @buyer_details = buyer_details
        @channel = channel
        @state = state
      end
    end
  end
end

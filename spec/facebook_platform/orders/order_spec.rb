# frozen_string_literal: true

require 'json'
require 'facebook_platform/api'
require 'facebook_platform/orders/order'

RSpec.describe FacebookPlatform::Orders::Order do
  context '.new' do
    it 'creates an instance and getters' do
      order = described_class.new(id: 123, buyer_details: nil, channel: 'facebook', state: 'CREATED')
      expect(order.id).to eq(123)
      expect(order.buyer_details).to eq(nil)
      expect(order.channel).to eq('facebook')
      expect(order.state).to eq('CREATED')
    end
  end

  context '.all' do
    let(:response) do
      JSON.parse('{
        "data": [
          {
            "id": "368508827392800",
            "buyer_details": {
              "name": "John Smith",
              "email": "n8miblde3i@marketplace.facebook.com",
              "email_remarketing_option": false
            },
            "channel": "facebook",
            "order_status": {
              "state": "CREATED"
            }
          }
        ],
        "paging": {
          "cursors": {
            "before": "QVFIUkxqeHRvVTN0OXpSWWE4X3FwVkRtUkxobkYtWlVGN0FQbVpVZAFE4VEpzOTFvNzhpcGV2QzhxX25ZAWk",
            "after": "QVFIUkxqeHRvVTN0OXpSWWE4X3FwVkRtUkxobkYtWlVGN0FQbVpVZAFE4VEpzOTFvNzhpcGV2QzhxX25Z"
          }
        }
      }')
    end

    it 'returns an objects array created from a request results hash' do
      expect(FacebookPlatform::API).to receive(:get).with(
        '12345/commerce_orders',
        access_token: 'ABC-123',
        fields: 'id,buyer_details,channel,merchant_order_id,order_status'
      ).and_return(response)

      results = described_class.all(page_id: '12345', access_token: 'ABC-123')
      first_record = results.first

      expect(first_record.id).to eq('368508827392800')
      expect(first_record.buyer_details.name).to eq('John Smith')
      expect(first_record.buyer_details.email).to eq('n8miblde3i@marketplace.facebook.com')
      expect(first_record.channel).to eq('facebook')
      expect(first_record.state).to eq('CREATED')
    end
  end
end

# frozen_string_literal: true

require 'json'
require 'facebook_platform/api'
require 'facebook_platform/orders/order'

# rubocop:disable Metrics/BlockLength
# rubocop:disable  Metrics/LineLength
RSpec.describe FacebookPlatform::Orders::Order do
  context '.new' do
    it 'creates an instance and getters' do
      order = described_class.new(
        'id' => 123,
        'buyer_details' => {
          'name' => 'Darth Vader',
          'email' => 'darth@deathstar.com'
        },
        'channel' => 'facebook',
        'order_status' => { 'state' => 'CREATED' },
        'estimated_payment_details' => {
          'total_amount' => {
            'amount' => '3.3',
            'currency' => 'USD'
          },
          'tax' => {
            'amount' => '1.1'
          },
          'subtotal' => {
            'items' => {
              'amount' => '2.1'
            },
            'shipping' => {
              'amount' => '0.1'
            }
          }
        },
        'shipping_address' => {
          'name' => 'Express',
          'street1' => '12 Queen Street',
          'street2' => '',
          'city' => 'Brisbane',
          'state' => 'QLD',
          'postal_code' => '4000',
          'country' => 'AU'
        },
        'created' => '2020-01-30T01:26:14+00:00',
        'last_updated' => '2020-02-25T01:14:12+00:00',
        'items' => [
          {
            'retailer_id' => '6545',
            'quantity' => 2
          }
        ]
      )
      expect(order.id).to eq(123)
      expect(order.buyer_details.name).to eq('Darth Vader')
      expect(order.buyer_details.email).to eq('darth@deathstar.com')
      expect(order.channel).to eq('facebook')
      expect(order.state).to eq('CREATED')
      expect(order.currency_code).to eq('USD')
      expect(order.total_amount).to eq(3.3)
      expect(order.total_tax_amount).to eq(1.1)
      expect(order.items_total_amount).to eq(2.1)
      expect(order.shipping_total_amount).to eq(0.1)
      expect(order.created_at).to eq(DateTime.parse('2020-01-30T01:26:14+00:00'))
      expect(order.updated_at).to eq(DateTime.parse('2020-02-25T01:14:12+00:00'))
      expect(order.shipping_address.name).to eq('Express')
      expect(order.shipping_address.street1).to eq('12 Queen Street')
      expect(order.shipping_address.street2).to eq('')
      expect(order.shipping_address.city).to eq('Brisbane')
      expect(order.shipping_address.state).to eq('QLD')
      expect(order.shipping_address.postal_code).to eq('4000')
      expect(order.shipping_address.country).to eq('AU')
      expect(order.items.first.retailer_id).to eq('6545')
      expect(order.items.first.quantity).to eq(2)
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
            },
            "estimated_payment_details": {
                "subtotal": {
                  "items": {
                    "amount": "2.00",
                    "currency": "USD"
                  },
                  "shipping": {
                    "amount": "0.00",
                    "currency": "USD"
                  }
                },
                "tax": {
                  "amount": "0.19",
                  "currency": "USD"
                },
                "total_amount": {
                  "amount": "2.19",
                  "currency": "USD"
                },
                "tax_remitted": true
            },
            "shipping_address": {
              "name": "Express",
              "street1": "12 Queen Street",
              "street2": "",
              "city": "Brisbane",
              "state": "QLD",
              "postal_code": "4000",
              "country": "AU"
            },
            "created": "2020-01-30T01:26:14+00:00",
            "last_updated": "2020-02-25T01:14:12+00:00",
            "items": [
              {
                "retailer_id": "12345",
                "quantity": 2
              }
            ]
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

    let(:response_with_next_page) do
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
            },
            "shipping_address": {
              "name": "Express",
              "street1": "12 Queen Street",
              "street2": "",
              "city": "Brisbane",
              "state": "QLD",
              "postal_code": "4000",
              "country": "AU"
            },
            "created": "2020-01-30T01:26:14+00:00",
            "last_updated": "2020-02-25T01:14:12+00:00",
            "items": []
          }
        ],
        "paging": {
          "cursors": {
            "before": "QVFIUkxqeHRvVTN0OXpSWWE4X3FwVkRtUkxobkYtWlVGN0FQbVpVZAFE4VEpzOTFvNzhpcGV2QzhxX25ZAWk",
            "after": "QVFIUkxqeHRvVTN0OXpSWWE4X3FwVkRtUkxobkYtWlVGN0FQbVpVZAFE4VEpzOTFvNzhpcGV2QzhxX25Z"
          },
          "next": "https://graph.facebook.com/vX.X/<page-id>/commerce_orders?access_token=--sanitized_key--&pretty=0&limit=25&after=--sanitized_key--"
        }
      }')
    end

    let(:second_page_response) do
      JSON.parse('{
        "data": [
          {
            "id": "123508827392800",
            "buyer_details": {
              "name": "Darth Vader",
              "email": "darth@marketplace.facebook.com",
              "email_remarketing_option": false
            },
            "channel": "facebook",
            "order_status": {
              "state": "IN_PROGRESS"
            },
            "shipping_address": {
              "name": "Express",
              "street1": "12 Queen Street",
              "street2": "",
              "city": "Brisbane",
              "state": "QLD",
              "postal_code": "4000",
              "country": "AU"
            },
            "created": "2020-01-30T01:26:14+00:00",
            "last_updated": "2020-02-25T01:14:12+00:00",
            "items": []
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

    it 'returns an objects array created from a request of not paginated results' do
      expect(FacebookPlatform::API).to receive(:get).with(
        '12345/commerce_orders',
        access_token: 'ABC-123',
        fields: 'id,buyer_details,channel,merchant_order_id,order_status,estimated_payment_details,created,last_updated,shipping_address,items'
      ).and_return(response)

      results = described_class.all(page_id: '12345', access_token: 'ABC-123')
      first_record = results.first

      expect(first_record.id).to eq('368508827392800')
      expect(first_record.buyer_details.name).to eq('John Smith')
      expect(first_record.buyer_details.email).to eq('n8miblde3i@marketplace.facebook.com')
      expect(first_record.channel).to eq('facebook')
      expect(first_record.state).to eq('CREATED')
      expect(first_record.currency_code).to eq('USD')
      expect(first_record.total_amount).to eq(2.19)
      expect(first_record.total_tax_amount).to eq(0.19)
      expect(first_record.items_total_amount).to eq(2.00)
      expect(first_record.shipping_total_amount).to eq(0)
      expect(first_record.shipping_address.name).to eq('Express')
      expect(first_record.shipping_address.street1).to eq('12 Queen Street')
      expect(first_record.shipping_address.street2).to eq('')
      expect(first_record.shipping_address.city).to eq('Brisbane')
      expect(first_record.shipping_address.state).to eq('QLD')
      expect(first_record.shipping_address.postal_code).to eq('4000')
      expect(first_record.shipping_address.country).to eq('AU')
      expect(first_record.items.first.retailer_id).to eq('12345')
      expect(first_record.items.first.quantity).to eq(2)
    end

    it 'returns an objects array created from a request of paginated results' do
      expect(FacebookPlatform::API).to receive(:get).with(
        '12345/commerce_orders',
        access_token: 'ABC-123',
        fields: 'id,buyer_details,channel,merchant_order_id,order_status,estimated_payment_details,created,last_updated,shipping_address,items'
      ).and_return(response_with_next_page)

      expect(FacebookPlatform::API).to receive(:get).with(
        '12345/commerce_orders?access_token=--sanitized_key--&pretty=0&limit=25&after=--sanitized_key--', {}
      ).and_return(second_page_response)

      results = described_class.all(page_id: '12345', access_token: 'ABC-123')
      expect(results.size).to eq(2)

      first_record = results.first
      expect(first_record.id).to eq('368508827392800')
      expect(first_record.buyer_details.name).to eq('John Smith')
      expect(first_record.buyer_details.email).to eq('n8miblde3i@marketplace.facebook.com')
      expect(first_record.channel).to eq('facebook')
      expect(first_record.state).to eq('CREATED')

      second_record = results.last
      expect(second_record.id).to eq('123508827392800')
      expect(second_record.buyer_details.name).to eq('Darth Vader')
      expect(second_record.buyer_details.email).to eq('darth@marketplace.facebook.com')
      expect(second_record.channel).to eq('facebook')
      expect(second_record.state).to eq('IN_PROGRESS')
    end
  end
end
# rubocop:enable Metrics/BlockLength
# rubocop:enable Metrics/LineLength

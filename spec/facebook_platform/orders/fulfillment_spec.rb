# frozen_string_literal: true

require 'facebook_platform/api'
require 'facebook_platform/orders/fulfillment'

RSpec.describe FacebookPlatform::Orders::Fulfillment do
  context '.create' do
    let(:example_request) do
      JSON.parse(
        '{
        "external_shipment_id": "external_shipment_1",
        "items": [
          {
            "retailer_id": "FB_product_1238",
            "quantity": 1
          },
          {
            "retailer_id": "FB_product_5624",
            "quantity": 2
          }
        ],
        "tracking_info": {
          "tracking_number": "ship 1",
          "carrier": "FEDEX",
          "shipping_method_name": "2 Day Fedex"
        },
        "fulfillment": {
          "fulfillment_location_id": "2153613121365"
        },
        "idempotency_key": "cb091e84-e75a-3a34-45d3-5153bec88b65"}'
      )
    end

    let(:shipment1) { described_class::Shipment.new(retailer_id: 'FB_product_1238', quantity: 1) }
    let(:shipment2) { described_class::Shipment.new(retailer_id: 'FB_product_5624', quantity: 2) }
    let(:shipments) { [shipment1, shipment2] }
    let(:tracking_info) { described_class::TrackingInfo.new(tracking_number: 'ship 1', carrier: 'FEDEX') }

    it 'returns success' do
      expect(SecureRandom).to receive(:uuid).and_return('UUID')
      expect(FacebookPlatform::API).to receive(:post).with(
        '64000841784004/shipments',
        access_token: 'ABC-123',
        items: [{ retailer_id: 'FB_product_1238', quantity: 1 }, { retailer_id: 'FB_product_5624', quantity: 2 }],
        tracking_info: { tracking_number: 'ship 1', carrier: 'FEDEX' },
        idempotency_key: 'UUID'
      ).and_return('success' => true)

      result = described_class.create(
        order_id: '64000841784004',
        shipments: shipments,
        tracking_info: tracking_info,
        access_token: 'ABC-123'
      )
      expect(result).to be_truthy
    end

    it 'returns false' do
      expect(SecureRandom).to receive(:uuid).and_return('UUID')
      expect(FacebookPlatform::API).to receive(:post).with(
        '64000841784004/shipments',
        access_token: 'ABC-123',
        items: [],
        tracking_info: {},
        idempotency_key: 'UUID'
      ).and_return('success' => false)

      result = described_class.create(
        order_id: '64000841784004',
        shipments: [],
        tracking_info: nil,
        access_token: 'ABC-123'
      )
      expect(result).to be_falsey
    end
  end
end

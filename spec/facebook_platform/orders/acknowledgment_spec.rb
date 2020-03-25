# frozen_string_literal: true

require 'facebook_platform/api'
require 'facebook_platform/orders/acknowledgement'

RSpec.describe FacebookPlatform::Orders::Acknowledgement do
  context '.new' do
    it 'creates an instance and getters' do
      acknowledgement = described_class.new(
        order_id: 123,
        state: 'IN_PROGRESS',
        error: { 'error_code' => 236_100_3, 'error_message' => 'Invalid Order ID' }
      )
      expect(acknowledgement.order_id).to eq(123)
      expect(acknowledgement.state).to eq('IN_PROGRESS')
      expect(acknowledgement.error).to eq({ 'error_code' => 236_100_3, 'error_message' => 'Invalid Order ID' })
    end
  end

  context '.create' do
    it 'returns an objects created from a request results hash with state' do
      expect(SecureRandom).to receive(:uuid).and_return('UUID')
      expect(FacebookPlatform::API).to receive(:post).with(
        '64000841784004/acknowledge_order',
        access_token: 'ABC-123',
        idempotency_key: 'UUID'
      ).and_return('id' => '64000841784004', 'state' => 'IN_PROGRESS')

      result = described_class.create(order_id: '64000841784004', access_token: 'ABC-123')
      expect(result).to be_kind_of(described_class)
      expect(result).to have_attributes(order_id: '64000841784004', state: 'IN_PROGRESS', error: nil)
    end

    it 'returns an objects created from a request results hash with error' do
      expect(SecureRandom).to receive(:uuid).and_return('UUID')
      expect(FacebookPlatform::API).to receive(:post).with(
        '64000841784004/acknowledge_order',
        access_token: 'ABC-123',
        idempotency_key: 'UUID'
      ).and_return(
        'id' => '64000841784004',
        'error' => { 'error_code' => 236_100_3, 'error_message' => 'Invalid Order ID' }
      )

      result = described_class.create(order_id: '64000841784004', access_token: 'ABC-123')
      expect(result).to be_kind_of(described_class)
      expect(result)
        .to have_attributes(order_id: '64000841784004',
                            state: nil,
                            error: { 'error_code' => 236_100_3, 'error_message' => 'Invalid Order ID' })
    end
  end
end

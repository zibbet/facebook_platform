# frozen_string_literal: true

require 'facebook_platform/api'
require 'facebook_platform/businesses/system_user'

RSpec.describe FacebookPlatform::Businesses::SystemUser do
  context '.new' do
    it 'creates an instance and getters' do
      system_user = described_class.new(id: 123, name: 'Darth Vader', role: 'ADMIN')
      expect(system_user.id).to eq(123)
      expect(system_user.name).to eq('Darth Vader')
      expect(system_user.role).to eq('ADMIN')
    end

    it 'raises an error if role is invalid' do
      expect do
        described_class.new(id: 123, name: 'Darth Vader', role: 'Jedi')
      end.to raise_error(ArgumentError, 'The valid roles are ADMIN,EMPLOYEE')
    end
  end

  context '.all' do
    it 'returns an objects array created from a request results hash' do
      expect(FacebookPlatform::API).to receive(:get).with(
        '123/system_users',
        access_token: 'ABC-123'
      ).and_return(
        'data' =>
          [
            {
              'id' => '1',
              'name' => 'Darth Vader',
              'role' => 'ADMIN'
            }
          ]
      )

      result = described_class.all(access_token: 'ABC-123', business_id: '123')
      expect(result.first).to have_attributes(id: '1', name: 'Darth Vader', role: 'ADMIN')
    end
  end

  context '.create' do
    it 'returns a created object serialized from hash' do
      expect(FacebookPlatform::API).to receive(:post).with(
        '123/system_users',
        access_token: 'ABC-123',
        role: 'ADMIN',
        name: 'Darth Vader'
      ).and_return('id' => '100041623866064')
      result = described_class.create(access_token: 'ABC-123', business_id: '123', role: 'ADMIN', name: 'Darth Vader')
      expect(result).to have_attributes(id: '100041623866064', name: 'Darth Vader', role: 'ADMIN')
    end

    it 'raises an exception if role is invalid' do
      expect do
        expect(FacebookPlatform::API).to_not receive(:post)
        described_class.create(access_token: 'ABC-123', business_id: '123', role: 'Jedi', name: 'Darth Vader')
      end.to raise_error(ArgumentError, 'The valid roles are ADMIN,EMPLOYEE')
    end
  end

  context '.assign_page_permissions' do
    it 'returns true on success' do
      expect(FacebookPlatform::API).to receive(:post).with(
        '123456/assigned_users',
        access_token: 'ABC-123',
        user: '9999',
        tasks: ['MANAGE']
      ).and_return('success' => true)
      result = described_class.assign_page_permissions(
        access_token: 'ABC-123',
        page_id: '123456',
        system_user_id: '9999'
      )
      expect(result).to be_truthy
    end
  end

  context '.assign_assets' do
    it 'returns true on success' do
      expect(FacebookPlatform::API).to receive(:post).with(
        '123456/assigned_users',
        access_token: 'ABC-123',
        user: '9999',
        tasks: ['MANAGE'],
        business: '98'
      ).and_return('success' => true)
      result = described_class.assign_assets(
        access_token: 'ABC-123',
        asset_id: '123456',
        system_user_id: '9999',
        business_id: '98'
      )
      expect(result).to be_truthy
    end
  end

  context '.get_id' do
    it 'returns user id' do
      expect(FacebookPlatform::API).to receive(:get).with(
        '/me',
        access_token: 'ABC-123',
        fields: 'id'
      ).and_return('id' => 544)
      result = described_class.get_id(
        access_token: 'ABC-123'
      )
      expect(result).to eq(544)
    end
  end

  context '#admin' do
    it 'truthy id role is ADMIN' do
      obj = described_class.new(id: 1, role: 'ADMIN', name: 'Darth Vader')
      expect(obj.admin?).to be_truthy
    end

    it 'falsey id role is not ADMIN' do
      obj = described_class.new(id: 1, role: 'EMPLOYEE', name: 'Darth Vader')
      expect(obj.admin?).to be_falsey
    end
  end

  context '#generate_access_token' do
    it 'generates a long term access token for system user' do
      expect(FacebookPlatform::API).to receive(:post).with(
        '1234567890/access_tokens',
        business_app: '123',
        scope: 'business_management,manage_pages',
        appsecret_proof: '542e3ca3202c918604c6be2a3baaafdec08b86d4194797bf370a745a26ae7b82',
        access_token: 'ABC123'
      ).and_return('access_token' => 'PERMANENT_TOKEN_123')

      system_user = described_class.new(id: '1234567890', role: 'ADMIN', name: 'Darth Vader')
      token = system_user.generate_access_token(
        app_id: '123',
        app_secret: 'ABC',
        scope: 'business_management,manage_pages',
        access_token: 'ABC123'
      )
      expect(token).to eq('PERMANENT_TOKEN_123')
    end
  end
end

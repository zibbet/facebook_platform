# frozen_string_literal: true

module FacebookPlatform
  module Businesses
    # represents Facebook's System User entity
    class SystemUser
      attr_reader :id, :name, :role

      VALID_ROLES = %w[ADMIN EMPLOYEE].freeze

      def self.all(access_token:, business_id:)
        result = API.get("#{business_id}/system_users", access_token: access_token)
        result['data'].map { |hash| new(id: hash['id'], name: hash['name'], role: hash['role']) }
      end

      def self.create(access_token:, business_id:, role:, name:)
        validate_role(role)
        result = API.post("#{business_id}/system_users", access_token: access_token, role: role, name: name)
        new(id: result['id'], name: name, role: role)
      end

      # https://developers.facebook.com/docs/marketing-api/businessmanager/systemuser/?hc_location=ufi#permissions
      # system_user_id - System user id that you created
      # Tasks - Access type for this system user for Page:
      # ['MANAGE'], ['CREATE_CONTENT'], ['MODERATE'], ['ADVERTISE'] and ['ANALYZE']
      # access_token - of admin user or admin system user.
      def self.assign_page_permissions(access_token:, page_id:, system_user_id:, tasks: ['MANAGE'])
        result = API.post("#{page_id}/assigned_users", access_token: access_token, user: system_user_id, tasks: tasks)
        result['success']
      end

      # Assign assets(Page, Catalog, Pixel etc) to SYSTEM USER in clients business manager.
      # Access Token Used: USERS_ACCESS_TOKEN, tasks EDIT ANALYZE MANAGE etc
      def self.assign_assets(access_token:, system_user_id:, business_id:, asset_id:, tasks: ['MANAGE'])
        result = API.post(
          "#{asset_id}/assigned_users",
          access_token: access_token,
          user: system_user_id,
          tasks: tasks,
          business: business_id
        )
        result['success']
      end

      def self.get_id(access_token:)
        result = API.get('me', access_token: access_token, fields: 'id')
        result['id']
      end

      def self.validate_role(value)
        raise ArgumentError, "The valid roles are #{VALID_ROLES.join(',')}" unless VALID_ROLES.include?(value)
      end

      def initialize(id:, name:, role:)
        @id = id
        @name = name
        @role = role
        validate_role(role)
      end

      def generate_access_token(app_id:, app_secret:, scope:, access_token:)
        hmac = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), app_secret, access_token)
        result = API.post(
          "#{@id}/access_tokens",
          business_app: app_id,
          scope: scope,
          appsecret_proof: hmac,
          access_token: access_token
        )
        result['access_token']
      end

      def admin?
        @role == 'ADMIN'
      end

      private

      def validate_role(value)
        self.class.validate_role(value)
      end
    end
  end
end

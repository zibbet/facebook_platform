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

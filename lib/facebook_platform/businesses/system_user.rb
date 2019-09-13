module FacebookPlatform
  module Businesses
    # represents Facebook's System User entity
    class SystemUser
      attr_reader :id, :name, :role

      VALID_ROLES = %w[ADMIN EMPLOYEE].freeze

      def self.all(access_token:, business_id:)
        json = API.get("#{business_id}/system_users", access_token: access_token)
        json.map { |hash| new(id: hash['id'], name: hash['name'], role: hash['role']) }
      end

      def self.create(access_token:, business_id:, role:, name:)
        validate_role(role)
        API.post("#{business_id}/system_users", access_token: access_token, role: role, name: name)
        # TODO: waiting FB approval
        # TODO: return SystemUserObject
        # {
        #   "id" : "100000008899900"
        # }
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

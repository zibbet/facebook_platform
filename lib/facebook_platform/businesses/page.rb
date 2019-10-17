# frozen_string_literal: true

module FacebookPlatform
  module Businesses
    # represents Facebook's Business Page entity
    class Page
      attr_reader :id, :name, :access_token

      def self.all(access_token:, business_id:)
        result = API.get("#{business_id}/owned_pages", access_token: access_token)
        result['data'].map { |hash| new(id: hash['id'], name: hash['name']) }
      end

      def initialize(id:, name:, access_token: '')
        @id = id
        @name = name
        @access_token = access_token
      end
    end
  end
end

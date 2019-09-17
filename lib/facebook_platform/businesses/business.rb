module FacebookPlatform
  module Businesses
    # represents Facebook's Business entity
    class Business
      attr_reader :id, :name

      def self.all(access_token:)
        result = API.get('me/businesses', access_token: access_token)
        result['data'].map { |hash| new(id: hash['id'], name: hash['name']) }
      end

      def initialize(id:, name:)
        @id = id
        @name = name
      end
    end
  end
end

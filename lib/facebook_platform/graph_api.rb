module FacebookPlatform
  # The purpose of this class is to wrap the low level Facebook Graph API client - Koala
  class GraphAPI
    attr_reader :graph_api

    def initialize(access_token)
      @graph_api = Koala::Facebook::API.new(access_token)
    end

    def connections(id:, name:)
      @graph_api.get_connections(id, name)
    end

    def create_connection(id:, name:, params: {})
      @graph_api.put_connections(id, name, params)
    end
  end
end

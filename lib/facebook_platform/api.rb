module FacebookPlatform
  # The purpose of this class is to abstract HTTP based communication with Facebook API
  class API
    # custom exception type if Facebook API returns an error
    class Error < StandardError
      attr_reader :type, :code, :fbtrace_id

      def initialize(error_details:)
        @type = error_details['type']
        @code = error_details['code']
        @fbtrace_id = error_details['fbtrace_id']
        super(error_details['message'])
      end
    end

    def self.base_url
      'https://graph.facebook.com'
    end

    def self.version
      ENV['FACEBOOK_API_VERSION'] || 'v4.0'
    end

    def self.api_url(path = '')
      "#{base_url}/#{version}/#{path}"
    end

    def self.get(path, params)
      request(:get, path, params)
    end

    def self.post(path, params)
      request(:post, path, params)
    end

    def self.request(method, path, params = {})
      resp = Faraday.send(method, api_url(path), params)
      body = JSON.parse(resp.body)
      raise Error.new(error_details: body['error']) if body['error']

      body
    end
  end
end

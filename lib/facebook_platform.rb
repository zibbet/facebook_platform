# frozen_string_literal: true

require 'faraday'
require 'json'
require 'openssl'

require 'facebook_platform/version'
require 'facebook_platform/api'
require 'facebook_platform/businesses/business'
require 'facebook_platform/businesses/system_user'

module FacebookPlatform
  class Error < StandardError; end
  # Your code goes here...
end

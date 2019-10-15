# frozen_string_literal: true

require 'faraday'
require 'json'
require 'openssl'

require 'facebook_platform/version'
require 'facebook_platform/api'
require 'facebook_platform/businesses/business'
require 'facebook_platform/businesses/system_user'
require 'facebook_platform/businesses/page'
require 'facebook_platform/products/catalog'
require 'facebook_platform/pages/page'

module FacebookPlatform
  class Error < StandardError; end
  # Your code goes here...
end

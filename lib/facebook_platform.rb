# frozen_string_literal: true

require 'faraday'
require 'json'
require 'openssl'

require 'facebook_platform/version'
require 'facebook_platform/api'
require 'facebook_platform/businesses/aggregator'
require 'facebook_platform/businesses/business'
require 'facebook_platform/businesses/merchant_onboarding'
require 'facebook_platform/businesses/system_user'
require 'facebook_platform/businesses/page'
require 'facebook_platform/orders/order'
require 'facebook_platform/orders/acknowledgement'
require 'facebook_platform/products/catalog'
require 'facebook_platform/products/feed'
require 'facebook_platform/products/upload'
require 'facebook_platform/products/product'
require 'facebook_platform/pages/page'

module FacebookPlatform
  class Error < StandardError; end
  # Your code goes here...
end

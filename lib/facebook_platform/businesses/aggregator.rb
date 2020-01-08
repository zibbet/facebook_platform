# frozen_string_literal: true

module FacebookPlatform
  module Businesses
    # https://developers.facebook.com/docs/commerce-platform/platforms/obo
    # represents Aggregator On Behalf Of relationship between Partner and Clients Business Manager
    class Aggregator
      # This will install the app in the client business manager and create a System user.
      # Name of the system user is "{Client_Business_Manager_Name} SYSTEM USER"
      # Access Token Used: USERS_ACCESS_TOKEN
      def self.create(access_token:, partner_business_id:, client_business_id:)
        API.post(
          "#{partner_business_id}/managed_businesses",
          access_token: access_token,
          existing_client_business_id: client_business_id
        )
      end

      # Create a system user and fetch the access token under the clients business manager
      # Access Token Used: PARTNER_BM_ADMIN_SYSTEM_USER_ACCESS_TOKEN
      # curl -X POST \
      #  -F 'scope="ads_management,manage_pages"' \
      #  -F 'app_id={APP_ID}' \
      #  -F 'access_token=<ACCESS_TOKEN>' \
      #  https://graph.facebook.com/{MERCHANTS_BM_ID}/access_token
      def self.create_client_system_user(access_token:, app_id:, business_id:, scope: 'ads_management,manage_pages')
        result = API.post(
          "#{business_id}/access_token",
          access_token: access_token,
          app_id: app_id,
          scope: scope
        )
        result['access_token']
      end
    end
  end
end

# frozen_string_literal: true

# This module is responsible for downloading JSON data from ad service.
# @example
#   AdServiceClient.ads
module AdServiceClient
  class << self
    # Downloads and parses JSON from ad service
    # @return [Array<Hash>]
    def ads
      response = connection.get(Thinker.ad_service_url)
      JSON.parse(response.body)['ads'].each_with_object({}) { |ad, hash| hash[ad['reference']] = ad.symbolize_keys }
    end

    # Creates a Faraday connection instance.
    # @return [Faraday::Connection]
    def connection
      @connection ||= Faraday.new do |faraday|
        faraday.use      Faraday::Response::RaiseError
        faraday.request  :url_encoded
        faraday.adapter  Faraday.default_adapter
      end
    end
  end
end

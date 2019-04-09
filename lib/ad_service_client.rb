# frozen_string_literal: true

module Thinker
  # This module is responsible for downloading JSON data from ad service.
  # @example
  #   Thinker::AdServiceClient.ads
  module AdServiceClient
    class << self
      # Downloads and parses JSON from ad service
      # @return [Array<Hash>]
      def ads
        response = connection.get(Thinker.ad_service_url)
        JSON.parse(response.body)
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
end

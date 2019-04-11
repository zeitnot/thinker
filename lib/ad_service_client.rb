# frozen_string_literal: true

# This module is responsible for downloading and parsing JSON data from ad service.
# @example
#   AdServiceClient.ads #=>
#   {
#       '1' => { reference: '1', status: 'enabled', description: 'Description for campaign 10' },
#       '2' => { reference: '2', status: 'enabled', description: 'Description for campaign 11' }
#   }
module AdServiceClient
  class << self
    # Downloads and parses JSON from ad service
    # @return [Array<Hash>, nil] returns nil in case of client specific errors.
    def ads
      with_rescue do
        response = connection.get(Thinker.ad_service_url)
        parse_json(response)
      end
    end

    # Creates a Faraday connection instance.
    # @return [Faraday::Connection]
    def connection
      @connection ||= Faraday.new do |faraday|
        options               = faraday.options
        options.timeout       = Thinker.read_timeout
        options.open_timeout  = Thinker.open_timeout

        faraday.use      Faraday::Response::RaiseError
        faraday.request  :url_encoded
        faraday.adapter  Faraday.default_adapter
      end
    end

    # Decides whether to retry the failed request or not.
    def retry?(exception, num_retries)
      return false if num_retries >= Thinker.max_network_retries

      # Retry on timeout-related problems (either on open or read).
      return true if exception.is_a?(Faraday::TimeoutError)

      # Destination refused the connection, the connection was reset, or a
      # variety of other connection failures.
      return true if exception.is_a?(Faraday::ConnectionFailed)

      if exception.is_a?(Faraday::ClientError)
        response = exception.response
        # 409 conflict
        return true if response && response[:status] == 409
      end

      false
    end

    def with_rescue
      retry_count = 0
      begin
        yield
      rescue StandardError => exception
        retry_count += 1
        retry if retry?(exception, retry_count)
        raise unless exception.is_a?(Faraday::ClientError)

        puts "Client Error: #{exception.message}" # monitoring
      end
    end

    # Parses JSON data in safe way. If there is exception while parsing nil will be returned.
    # @param [Faraday::Response,nil]
    # @return [Hash, nil]
    def parse_json(response)
      return unless response

      begin
        body = response.body
        json = JSON.parse(body)['ads']
        json.each_with_object({}) { |ad, hash| hash[ad['reference']] = ad.symbolize_keys }
      rescue StandardError => exception
        # Monitoring
        puts "Parsing failed: #{exception.message}"
      end
    end
  end
end

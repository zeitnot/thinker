# frozen_string_literal: true

require 'thinker/version'

require 'faraday'
require 'json'

require 'thinker/util'
require 'ad_service_client'
require 'campaign'
require 'compare_ads'
require 'find_discrepancy'

# Configurations goes here.
module Thinker
  # Fields to be compared. Keys are corresponding to local fields. However, values are corresponding to remote fields.
  TARGET_FIELDS_MAP = { ad_description: :description, status: :status }.freeze
  STATUS_MAP        = { enabled: :active, disabled: :paused }.freeze
  LOCAL_FIELDS      = TARGET_FIELDS_MAP.keys.freeze

  @ad_service_url       = 'https://mockbin.org/bin/fcb30500-7b98-476f-810d-463a0b8fc3df'
  @max_network_retries  = 3
  @open_timeout         = 10
  @read_timeout         = 30

  class << self
    # :reek:Attribute
    attr_accessor :ad_service_url
    attr_reader :max_network_retries, :open_timeout, :read_timeout

    # @return [Integer]
    def max_network_retries=(val)
      @max_network_retries = Integer(val)
    end

    # @return [Integer]
    def open_timeout=(val)
      @open_timeout = Integer(val)
    end

    # @return [Integer]
    def read_timeout=(val)
      @read_timeout = Integer(val)
    end
  end
end

# frozen_string_literal: true

require 'thinker/version'

require 'faraday'
require 'json'

require 'ad_service_client'

module Thinker
  @ad_service_url = 'https://mockbin.org/bin/fcb30500-7b98-476f-810d-463a0b8fc3df'

  class << self
    attr_accessor :ad_service_url
  end
end

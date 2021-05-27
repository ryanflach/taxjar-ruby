require 'taxjar/api/api'
require 'taxjar/api/customer'
require 'taxjar/api/order'
require 'taxjar/api/refund'
require 'taxjar/error'
require 'taxjar/api/request'
require 'taxjar/api/utils'

module Taxjar
  class Client
    include Taxjar::API
    include Taxjar::API::Customer
    include Taxjar::API::Order
    include Taxjar::API::Refund

    attr_accessor :api_key
    attr_accessor :api_url
    attr_accessor :headers
    attr_accessor :http_proxy
    attr_accessor :custom_nexus_regions

    def initialize(options = {})
      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
      yield(self) if block_given?
    end

    def api_key?
      !!@api_key
    end

    def set_api_config(key, value)
      validate_nexus(value) if key == 'custom_nexus_regions'
      instance_variable_set("@#{key}", value)
    end

    def get_api_config(key)
      instance_variable_get("@#{key}")
    end

    def user_agent
      def platform
        (`uname -a` || '').strip
      rescue Errno::ENOENT, Errno::ENOMEM
        ''
      end
      ruby_version = "ruby #{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}"
      openSSL_version = OpenSSL::OPENSSL_LIBRARY_VERSION
      "TaxJar/Ruby (#{platform}; #{ruby_version}; #{openSSL_version}) taxjar-ruby/#{Taxjar::Version}"
    end

    private

    def validate_nexus(value)
      raise 'custom_nexus_regions must be an array of 2-character strings' unless value.is_a?(Array) && value.all? { |v| v.is_a?(String) && v.length == 2 }
    end
  end
end

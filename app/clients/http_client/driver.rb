class HttpClient::Driver
  class ConnectionFailed < StandardError; end

  # @param url [String]
  attr_accessor :url

  # @param options [Hash]
  attr_accessor :options

  # @param url [String]
  def initialize(url:, options: {})
    @url = url
    @options = options
  end

  # @param path [String]
  # @param params [Hash<#to_s, String>]
  # @param headers [Hash<#to_s, String>]
  def get(path, params: {}, headers: {}, &block)
    fail NotImplementedError
  end

  # @param path [String]
  # @param body [Hash<#to_s, String>]
  # @param headers [Hash<#to_s, String>]
  # @param multipart [Boolean]
  # @param form_data [Array]
  def post(path, body: {}, headers: {}, multipart: false, form_data: [], &block)
    fail NotImplementedError
  end

  # @param path [String]
  # @param body [Hash<#to_s, String>]
  # @param headers [Hash<#to_s, String>]
  def put(path, body: {}, headers: {}, &block)
    fail NotImplementedError
  end

  # @param path [String]
  # @param body [Hash<#to_s, String>]
  # @param headers [Hash<#to_s, String>]
  def patch(path, body: {}, headers: {}, &block)
    fail NotImplementedError
  end

  # @param path [String]
  # @param params [Hash<#to_s, String>]
  # @param headers [Hash<#to_s, String>]
  def delete(path, params: {}, headers: {}, &block)
    fail NotImplementedError
  end
end

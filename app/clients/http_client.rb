class HttpClient
  class ConnectionFailed < StandardError; end

  # @return [HttpClient::Driver]
  attr_reader :driver

  # @return [String]
  attr_reader :url

  # @return [Hash]
  attr_reader :options

  # @param url [String]
  # @param driver [HttpClient::Driver]
  def initialize(url:, driver_class: HttpClient::FaradayDriver, options: {})
    @driver = driver_class.new(
      url: url,
      options: options
    )
    @url = url
    @options = options
  end

  def self.delegate_to_driver(method)
    define_method(method.to_sym) do |*args, &block|
      begin
        driver.public_send method.to_sym, *args, &block
      rescue HttpClient::Driver::ConnectionFailed => e
        raise ConnectionFailed, e.message
      end
    end
  end

  delegate_to_driver :get
  delegate_to_driver :post
  delegate_to_driver :put
  delegate_to_driver :patch
  delegate_to_driver :delete
end

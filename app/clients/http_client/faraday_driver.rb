class HttpClient::FaradayDriver < HttpClient::Driver
  class ResponseStreamNotSupportedError < StandardError; end
  class MultipartFormDataRequiredError < StandardError; end

  def initialize(url:, options: {})
    super(url: url, options: options)
  end

  # @see HttpClient#get
  def get(path, params: {}, headers: {})
    response = make_request(:get) do |request|
      request.url path
      request.params = params
      request.options.params_encoder = options[:params_encoder] if options[:params_encoder]
      request.headers = headers.merge connection.headers
    end

    Http::Response.new(
      status: response.status,
      body: response.body
    )
  end

  # @see HttpClient#post
  def post(path, body: {}, headers: {}, multipart: false, form_data: [])
    response = make_request(:post) do |request|
      request.url path
      request.body = headers["Content-Type"].nil? ? body.to_json : body
      request.headers = headers.merge connection.headers
      request.headers["Content-Type"] = "application/json" if headers["Content-Type"].nil?
    end

    Http::Response.new(
      status: response.status,
      body: response.body
    )
  end

  # @see HttpClient#put
  def put(path, body: {}, headers: {})
    raise ResponseStreamNotSupportedError if block_given?

    response = make_request(:put) do |request|
      request.url path
      request.body = body.to_json
      request.headers = headers.merge connection.headers
      request.headers["Content-Type"] = "application/json" if headers["Content-Type"].nil?
    end

    Http::Response.new(
      status: response.status,
      body: response.body
    )
  end

  # @see HttpClient#patch
  def patch(path, body: {}, headers: {})
    raise ResponseStreamNotSupportedError if block_given?

    response = make_request(:patch) do |request|
      request.url path
      request.body = body.to_json
      request.headers = headers.merge connection.headers
      request.headers["Content-Type"] = "application/json" if headers["Content-Type"].nil?
    end

    Http::Response.new(
      status: response.status,
      body: response.body
    )
  end

  # @see HttpClient#delete
  def delete(path, body: {}, headers: {})
    raise ResponseStreamNotSupportedError if block_given?

    response = make_request(:delete) do |request|
      request.url path
      request.body = body.to_json
      request.headers = headers.merge! connection.headers
      request.headers["Content-Type"] = "application/json" if headers["Content-Type"].nil?
    end

    Http::Response.new(
      status: response.status,
      body: response.body
    )
  end

  private

  def make_request(method, &block)
    connection.public_send(method, &block)
  rescue Faraday::ConnectionFailed => e
    raise HttpClient::Driver::ConnectionFailed, e.message
  rescue Faraday::ClientError => e
    e.response
  end

  def connection
    Faraday.new(url: url) do |faraday|
      faraday.request options[:request] if options[:request]
      faraday.response :logger, ::Logger.new(STDOUT), bodies: true if Rails.env.development?
      faraday.use FaradayMiddleware::ParseJson, :content_type => /\bjson$/
      faraday.adapter options[:adapter] || Faraday.default_adapter
    end
  end
end

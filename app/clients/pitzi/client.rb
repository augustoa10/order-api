module Pitzi
  class Client
    class CommunicationError < StandardError; end

    BASE_URL = "#{ENV.fetch('PITZI_PROTOCOL')}://#{ENV.fetch('PITZI_HOST')}:#{ENV.fetch('PITZI_PORT')}".freeze

    attr_reader :http_client

    # @param http_client [HttpClient]
    def initialize(http_client: HttpClient.new(url: BASE_URL))
      @http_client = http_client
    end

    def devices(name:)
      response = http_client.get(
        "/loja/autocomplete_produto_nome_completo",
        params: { term: name }.compact,
        headers: { "Content-Type": "application/json" }
      )

      if response.server_error? || response.client_error?
        fail CommunicationError, "#{response.status}: #{response.body}"
      end

      parse_devices(response.body)
    end

    private

    def parse_devices(devices)
      devices.map { |device| Device.new(id: device["id"], name: device["label"]) }
    end
  end
end

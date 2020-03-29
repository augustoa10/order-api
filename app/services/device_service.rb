class DeviceService
  class ListError < StandardError; end

  # @return [Pitzi::Client]
  attr_reader :device_client

  # @param device_client [Pitzi::Client]
  def initialize(device_client: Pitzi::Client.new)
    @device_client = device_client
  end

  # @param name [String]
  #
  # @return [Array<Device>]
  def list(name:)
    device_client.devices(name: name)
  rescue Pitzi::Client::CommunicationError => e
    raise ListError, I18n.t("errors.messages.device.list_device_error", message: e.message)
  end
end

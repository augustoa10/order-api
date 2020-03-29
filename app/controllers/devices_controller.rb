class DevicesController < ApplicationController
  def list
    devices = device_service.list(name: device_params[:name])

    render json: devices
  rescue DeviceService::ListError => e
    render json: { error: e.message, code: :device_list_error }, status: :unprocessable_entity
  end

  private

  def device_params
    params.permit(:name)
  end

  def device_service
    @device_service ||= DeviceService.new
  end
end

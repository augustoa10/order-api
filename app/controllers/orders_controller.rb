class OrdersController < ApplicationController
  def create
    order = order_service.create(
      device_imei: order_params[:device_imei],
      device_model: order_params[:device_model],
      installments: order_params[:installments],
      plan_id: order_params[:plan_id],
      user_id: order_params[:user_id]
    )

    render json: { id: order.id }, status: :created
  rescue OrderService::CreateError => e
    render json: { error: e.message, code: :order_create_error }, status: :unprocessable_entity
  end

  def update
    order = order_service.update(id: order_params[:id], **order_params.except(:id))

    render json: { id: order.id }
  rescue OrderService::NotFoundError => e
    render json: { error: e.message, code: :order_not_found }, status: :not_found
  rescue OrderService::UpdateError => e
    render json: { error: e.message, code: :order_update_error }, status: :unprocessable_entity
  end

  def destroy
    order_service.destroy(id: order_params[:id])

    head :no_content
  rescue OrderService::NotFoundError => e
    render json: { error: e.message, code: :order_not_found }, status: :not_found
  end

  def list
    orders = order_service.list

    render json: orders
  end

  def find
    order = order_service.find(id: order_params[:id])

    render json: order
  rescue OrderService::NotFoundError => e
    render json: { error: e.message, code: :order_not_found }, status: :not_found
  end

  private

  def order_params
    params.permit(
      :id,
      :device_imei,
      :device_model,
      :installments,
      :plan_id,
      :user_id
    )
  end

  def order_service
    @order_service ||= OrderService.new
  end
end

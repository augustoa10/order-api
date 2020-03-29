class PlansController < ApplicationController
  def create
    plan = plan_service.create(
      name: plan_params[:name],
      description: plan_params[:description],
      yearly_price: plan_params[:yearly_price]
    )

    render json: { id: plan.id }, status: :created
  rescue PlanService::CreateError => e
    render json: { error: e.message, code: :plan_create_error }, status: :unprocessable_entity
  end

  def update
    plan = plan_service.update(id: plan_params[:id], **plan_params.except(:id))

    render json: { id: plan.id }
  rescue PlanService::NotFoundError => e
    render json: { error: e.message, code: :plan_not_found }, status: :not_found
  rescue PlanService::UpdateError => e
    render json: { error: e.message, code: :plan_update_error }, status: :unprocessable_entity
  end

  def destroy
    plan_service.destroy(id: plan_params[:id])

    head :no_content
  rescue PlanService::NotFoundError => e
    render json: { error: e.message, code: :plan_not_found }, status: :not_found
  end

  def list
    plans = plan_service.list

    render json: plans
  end

  def find
    plan = plan_service.find(id: plan_params[:id])

    render json: plan
  rescue PlanService::NotFoundError => e
    render json: { error: e.message, code: :plan_not_found }, status: :not_found
  end

  private

  def plan_params
    params.permit(
      :id,
      :name,
      :description,
      :yearly_price
    )
  end

  def plan_service
    @plan_service ||= PlanService.new
  end
end

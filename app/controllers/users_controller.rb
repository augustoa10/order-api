class UsersController < ApplicationController
  def create
    user = user_service.create(
      name: user_params[:name],
      cpf: user_params[:cpf],
      email: user_params[:email]
    )

    render json: { id: user.id }, status: :created
  rescue UserService::CreateError => e
    render json: { error: e.message, code: :user_create_error }, status: :unprocessable_entity
  end

  def update
    user = user_service.update(id: user_params[:id], **user_params.except(:id))

    render json: { id: user.id }
  rescue UserService::NotFoundError => e
    render json: { error: e.message, code: :user_not_found }, status: :not_found
  rescue UserService::UpdateError => e
    render json: { error: e.message, code: :user_update_error }, status: :unprocessable_entity
  end

  def destroy
    user_service.destroy(id: user_params[:id])

    head :no_content
  rescue UserService::NotFoundError => e
    render json: { error: e.message, code: :user_not_found }, status: :not_found
  end

  def list
    users = user_service.list

    render json: users
  end

  def find
    user = user_service.find(id: user_params[:id])

    render json: user
  rescue UserService::NotFoundError => e
    render json: { error: e.message, code: :user_not_found }, status: :not_found
  end

  private

  def user_params
    params.permit(
      :id,
      :name,
      :cpf,
      :email
    )
  end

  def user_service
    @user_service ||= UserService.new
  end
end

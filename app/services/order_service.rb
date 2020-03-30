class OrderService
  class CreateError < StandardError; end
  class UpdateError < StandardError; end
  class NotFoundError < StandardError; end

  # @return [OrderRepository]
  attr_reader :order_repository

  # @return [PlanRepository]
  attr_reader :plan_repository

  # @return [UserRepository]
  attr_reader :user_repository

  # @param order_repository [OrderRepository]
  # @param plan_repository [PlanRepository]
  # @param user_repository [UserRepository]
  def initialize(
    order_repository: OrderRepository.new,
    plan_repository: PlanRepository.new,
    user_repository: UserRepository.new
  )
    @order_repository = order_repository
    @plan_repository = plan_repository
    @user_repository = user_repository
  end

  # @param device_imei [String]
  # @param device_model [String]
  # @param installments [Integer]
  # @param plan_id [Integer]
  # @param user_id [Integer]
  #
  # @return [Order]
  def create(device_imei:, device_model:, installments:, plan_id:, user_id:)
    user = user_repository.find_by_id(user_id)
    plan = plan_repository.find_by_id(plan_id)

    order_repository.create(
      device_imei: device_imei,
      device_model: device_model,
      installments: installments,
      plan_id: plan.id,
      user_id: user.id
    )
  rescue *[
    UserRepository::NotFoundError,
    PlanRepository::NotFoundError,
    OrderRepository::CreateError
  ] => e
    raise CreateError, I18n.t("errors.messages.order.create_order_error", message: e.message)
  end

  # @param id [Integer]
  # @param kwargs [Hash]
  #
  # @return [Plan]
  def update(id:, **kwargs)
    user_repository.find_by_id(kwargs[:user_id]) if kwargs[:user_id]
    plan_repository.find_by_id(kwargs[:plan_id]) if kwargs[:plan_id]

    order_repository.update(id: id, **kwargs)
  rescue UserRepository::NotFoundError, PlanRepository::NotFoundError => e
    raise UpdateError, I18n.t("errors.messages.order.update_order_error", message: e.message)
  rescue OrderRepository::NotFoundError => e
    raise NotFoundError, I18n.t("errors.messages.order.not_found_order_error", message: e.message)
  rescue OrderRepository::UpdateError => e
    raise UpdateError, I18n.t("errors.messages.order.update_order_error", message: e.message)
  end

  # @param id [Integer]
  #
  # @return [Boolean]
  def destroy(id:)
    order_repository.destroy(id: id)
  rescue OrderRepository::NotFoundError => e
    raise NotFoundError, I18n.t("errors.messages.order.not_found_order_error", message: e.message)
  end

  # @param id [Integer]
  #
  # @return [Plan]
  def find(id:)
    order_repository.find_by_id(id)
  rescue OrderRepository::NotFoundError => e
    raise NotFoundError, I18n.t("errors.messages.order.not_found_order_error", message: e.message)
  end

  # @return [Plan]
  def list
    order_repository.list
  end
end

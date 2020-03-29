class PlanService
  class CreateError < StandardError; end
  class UpdateError < StandardError; end
  class NotFoundError < StandardError; end

  # @return [PlanRepository]
  attr_reader :plan_repository

  # @param plan_repository [PlanRepository]
  def initialize(plan_repository: PlanRepository.new)
    @plan_repository = plan_repository
  end

  # @param name [String]
  # @param description [String]
  # @param yearly_price [Decimal]
  #
  # @return [Plan]
  def create(name:, description:, yearly_price:)
    plan_repository.create(name: name, description: description, yearly_price: yearly_price)
  rescue PlanRepository::CreateError => e
    raise CreateError, I18n.t("errors.messages.plan.create_plan_error", message: e.message)
  end

  # @param id [Integer]
  # @param kwargs [Hash]
  #
  # @return [Plan]
  def update(id:, **kwargs)
    plan_repository.update(id: id, **kwargs)
  rescue PlanRepository::NotFoundError => e
    raise NotFoundError, I18n.t("errors.messages.plan.not_found_plan_error", message: e.message)
  rescue PlanRepository::UpdateError => e
    raise UpdateError, I18n.t("errors.messages.plan.update_plan_error", message: e.message)
  end

  # @param id [Integer]
  #
  # @return [Boolean]
  def destroy(id:)
    plan_repository.destroy(id: id)
  rescue PlanRepository::NotFoundError => e
    raise NotFoundError, I18n.t("errors.messages.plan.not_found_plan_error", message: e.message)
  end

  # @param id [Integer]
  #
  # @return [Plan]
  def find(id:)
    plan_repository.find_by_id(id)
  rescue PlanRepository::NotFoundError => e
    raise NotFoundError, I18n.t("errors.messages.plan.not_found_plan_error", message: e.message)
  end

  # @return [Plan]
  def list
    plan_repository.list
  rescue PlanRepository::NotFoundError => e
    raise NotFoundError, I18n.t("errors.messages.plan.not_found_plan_error", message: e.message)
  end
end

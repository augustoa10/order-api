class PlanRepository
  class NotFoundError < StandardError; end
  class CreateError < StandardError; end
  class UpdateError < StandardError; end
  class DestroyError < StandardError; end

  # @return [Plan::ActiveRecord_Relation]
  attr_reader :scope

  # @param scope [Plan::ActiveRecord_Relation]
  def initialize(scope: Plan.unscoped)
    @scope = scope
  end

  # @param name [String]
  # @param description [String]
  # @param yearly_price [String]
  #
  # @return [Plan]
  def create(name:, description:, yearly_price:)
    scope.create!(
      name: name,
      description: description,
      yearly_price: yearly_price
    )
  rescue ActiveRecord::RecordInvalid => e
    raise CreateError, e.message
  end

  # @param id [Integer]
  #
  # @return [Plan]
  def destroy(id:)
    plan = find_by_id id
    plan.destroy
  end

  # @param id [Integer]
  #
  # @return [Plan]
  #
  # @raise [PlanRepository::NotFoundError]
  def find_by_id(id)
    scope.find_by! id: id
  rescue ActiveRecord::RecordNotFound
    raise NotFoundError, "Plan with id '#{id}' not found."
  end

  def list
    scope.all
  end

  # @param id [Integer]
  # @param kwargs [Hash]
  #
  # @return [Plan]
  def update(id:, **kwargs)
    plan = find_by_id id
    plan.update! **kwargs
    plan
  rescue ActiveRecord::RecordInvalid => e
    raise UpdateError, e.message
  end
end

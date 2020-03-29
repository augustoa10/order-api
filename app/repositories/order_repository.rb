class OrderRepository
  class NotFoundError < StandardError; end
  class CreateError < StandardError; end
  class UpdateError < StandardError; end
  class DestroyError < StandardError; end

  # @return [Order::ActiveRecord_Relation]
  attr_reader :scope

  # @param scope [Order::ActiveRecord_Relation]
  def initialize(scope: Order.unscoped)
    @scope = scope
  end

  # @param device_imei
  # @param device_model
  # @param installments
  # @param plan_id
  # @param user_id
  #
  # @return [Order]
  def create(
    device_imei:,
    device_model:,
    installments:,
    plan_id:,
    user_id:
  )
    scope.create!(
      device_imei: device_imei,
      device_model: device_model,
      installments: installments,
      plan_id: plan_id,
      user_id: user_id
    )
  rescue ActiveRecord::RecordInvalid => e
    raise CreateError, e.message
  end

  # @param id [Integer]
  #
  # @return [Order]
  def destroy(id:)
    order = find_by_id id
    order.destroy
  end

  # @param id [Integer]
  #
  # @return [Order]
  #
  # @raise [OrderRepository::NotFoundError]
  def find_by_id(id)
    scope.find_by! id: id
  rescue ActiveRecord::RecordNotFound
    raise NotFoundError, "Order with id '#{id}' not found."
  end

  def list
    scope.all
  end

  # @param id [Integer]
  # @param kwargs [Hash]
  #
  # @return [Order]
  def update(id:, **kwargs)
    order = find_by_id id
    order.update! **kwargs
    order
  rescue ActiveRecord::RecordInvalid => e
    raise UpdateError, e.message
  end
end

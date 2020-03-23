class UserRepository
  class NotFoundError < StandardError; end
  class CreateError < StandardError; end
  class UpdateError < StandardError; end
  class DestroyError < StandardError; end

  # @return [User::ActiveRecord_Relation]
  attr_reader :scope

  # @param scope [User::ActiveRecord_Relation]
  def initialize(scope: User.unscoped)
    @scope = scope
  end

  # @param name [String]
  # @param email [String]
  # @param cpf [String]
  #
  # @return [User]
  def create(name:, email:, cpf:)
    scope.create!(
      name: name,
      email: email,
      cpf: cpf
    )
  rescue ActiveRecord::RecordInvalid => e
    raise CreateError, e.message
  end

  # @param id [Integer]
  #
  # @return [User]
  def destroy(id:)
    user = find_by_id id
    user.destroy
  end

  # @param id [Integer]
  #
  # @return [User]
  #
  # @raise [UserRepository::NotFoundError]
  def find_by_id(id)
    scope.find_by! id: id
  rescue ActiveRecord::RecordNotFound
    raise NotFoundError, "User with id '#{id}' not found."
  end

  # @param email [String]
  #
  # @return [User]
  #
  # @raise [UserRepository::NotFoundError]
  def find_by_email(email)
    scope.find_by! email: email
  rescue ActiveRecord::RecordNotFound
    raise NotFoundError, "User with email '#{email}' not found."
  end

  def list
    scope.all
  end

  # @param id [Integer]
  # @param kwargs [Hash]
  #
  # @return [User]
  def update(id:, **kwargs)
    user = find_by_id id
    user.update! **kwargs
    user
  rescue ActiveRecord::RecordInvalid => e
    raise UpdateError, e.message
  end
end

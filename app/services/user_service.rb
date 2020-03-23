class UserService
  class CreateError < StandardError; end
  class UpdateError < StandardError; end
  class NotFoundError < StandardError; end

  # @return [UserRepository]
  attr_reader :user_repository

  # @param user_repository [UserRepository]
  def initialize(user_repository: UserRepository.new)
    @user_repository = user_repository
  end

  # @param name [String]
  # @param cpf [String]
  # @param email [String]
  #
  # @return [User]
  def create(name:, cpf:, email:)
    user_repository.create(name: name, cpf: cpf, email: email)
  rescue UserRepository::CreateError => e
    raise CreateError, I18n.t("errors.messages.create_user_error", message: e.message)
  end

  # @param id [Integer]
  # @param kwargs [Hash]
  #
  # @return [User]
  def update(id:, **kwargs)
    user_repository.update(id: id, **kwargs)
  rescue UserRepository::NotFoundError => e
    raise NotFoundError, I18n.t("errors.messages.not_found_user_error", message: e.message)
  rescue UserRepository::UpdateError => e
    raise UpdateError, I18n.t("errors.messages.update_user_error", message: e.message)
  end

  # @param id [Integer]
  #
  # @return [Boolean]
  def destroy(id:)
    user_repository.destroy(id: id)
  rescue UserRepository::NotFoundError => e
    raise NotFoundError, I18n.t("errors.messages.not_found_user_error", message: e.message)
  end

  # @param id [Integer]
  #
  # @return [User]
  def find(id:)
    user_repository.find_by_id(id)
  rescue UserRepository::NotFoundError => e
    raise NotFoundError, I18n.t("errors.messages.not_found_user_error", message: e.message)
  end

  # @return [User]
  def list
    user_repository.list
  rescue UserRepository::NotFoundError => e
    raise NotFoundError, I18n.t("errors.messages.not_found_user_error", message: e.message)
  end
end

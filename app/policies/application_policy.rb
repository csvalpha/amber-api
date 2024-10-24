class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user_or_application, record)
    @user = user_or_application if user_or_application.is_a? User
    @application = user_or_application if user_or_application.is_a? Doorkeeper::Application
    @record = record
  end

  def index?
    user&.permission?(:read, record)
  end

  def show?
    user&.permission?(:read, record)
  end

  def create?
    user&.permission?(:create, record)
  end

  def update?
    user&.permission?(:update, record)
  end

  def destroy?
    user&.permission?(:destroy, record)
  end

  def scope
    Pundit.policy_scope!(@user || @application, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user_or_application, scope)
      @user = user_or_application if user_or_application.is_a? User
      @application = user_or_application if user_or_application.is_a? Doorkeeper::Application
      @scope = scope
    end

    def resolve
      scope
    end

    def user_can_read?
      record = scope.try(:first) || scope
      user.try(:permission?, :read, record)
    end
  end
end

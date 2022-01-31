class UserPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      if user
        scope
      elsif tomato?
        scope.tomato_users
      end
    end

    def tomato?
      @application&.scopes&.include? 'tomato'
    end
  end

  def index?
    true
  end

  def show?
    scope.exists?(id: record.id)
  end

  def update?
    me? || super
  end

  def archive?
    destroy?
  end

  def resend_activation_mail?
    create?
  end

  def generate_otp_secret?
    me?
  end

  def activate_otp?
    me?
  end

  def activate_webdav?
    me?
  end

  def batch_import?
    create?
  end

  def create_with_user_permissions?(_permissions)
    true
  end

  def replace_user_permissions?(_permissions)
    true
  end

  private

  def me?
    record == user
  end
end

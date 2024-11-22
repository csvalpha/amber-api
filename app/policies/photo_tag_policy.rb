class PhotoTagPolicy < ApplicationPolicy
  def update?
    user_is_owner? || user_is_tagged? || super
  end

  def destroy?
    user_is_owner? || user_is_tagged? || super
  end

  def create_with_photo?(_photo)
    true
  end

  def replace_photo?(_photo)
    true
  end

  def create_with_tagged_user?(_user)
    true
  end

  def replace_tagged_user?(_user)
    true
  end

  private

  def user_is_owner?
    record.author == user
  end

  def user_is_tagged?
    record.tagged_user == user
  end
end

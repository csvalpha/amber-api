class ArticlePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user_can_read?
        scope
      else
        scope.publicly_visible
      end
    end
  end

  def index?
    true
  end

  def show?
    super || scope.where(id: record.id).exists?
  end

  def update?
    record.owners.include?(user) || super
  end

  def create_with_group?(_group)
    true
  end

  def replace_group?(_group)
    true
  end
end

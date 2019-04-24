class ArticleCommentPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
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
    scope.where(id: record.id).exists?
  end

  def create_with_article?(_article)
    true
  end

  def replace_article?(_article)
    true
  end
end

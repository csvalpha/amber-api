module Forum
  class PostPolicy < ApplicationPolicy
    def create?
      return super unless record.try(:thread).try(:closed?)

      user.permission?(:update, record.thread) && super
    end

    def update?
      return user_is_author? || super unless record.thread.closed?

      user.permission?(:update, record.thread) && super
    end

    def create_with_thread?(_thread)
      true
    end

    def replace_thread?(_thread)
      true
    end

    private

    def user_is_author?
      record.author == user
    end
  end
end

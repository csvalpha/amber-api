module Forum
  class ThreadPolicy < ApplicationPolicy
    def create_with_category?(_category)
      true
    end

    def replace_category?(_category)
      true
    end

    def create_with_author?(_author)
      true
    end

    def replace_author?(_author)
      true
    end
  end
end

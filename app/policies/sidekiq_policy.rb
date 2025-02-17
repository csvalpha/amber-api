class SidekiqPolicy < ApplicationPolicy
    class SidekiqPolicy
        attr_reader :user
      
        def initialize(user)
          @user = user
        end
      
        def access?
          user.has_role?(:sidekiq_access)
        end
      end
end

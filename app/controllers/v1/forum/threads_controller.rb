module V1::Forum
  class ThreadsController < V1::ApplicationController
    before_action :doorkeeper_authorize!
    before_action :set_model, only: %i[mark_read]

    def mark_read
      last = @model.posts.last
      thread = Forum::ReadThread.where(thread: @model, user: current_user).first_or_create! do |t|
        t.post = last
      end
      thread.update(post: last)
    end
  end
end

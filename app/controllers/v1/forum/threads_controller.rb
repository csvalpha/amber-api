module V1::Forum
  class ThreadsController < V1::ApplicationController
    def mark_read
      authorize @model

      Forum::UnreadThread.find_or_create_by(thread: @model, user: current_user).post = @model.last_post

      @model.destroy
    end
  end
end

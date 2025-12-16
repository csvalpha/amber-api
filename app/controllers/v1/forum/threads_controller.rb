# frozen_string_literal: true

module V1::Forum
  class ThreadsController < V1::ApplicationController
    include GraphitiCrud

    before_action :doorkeeper_authorize!
    before_action :set_model, only: %i[mark_read]

    graphiti_resource V1::Forum::ThreadResource

    def mark_read
      thread = Forum::ReadThread.where(thread: @model, user: current_user).first_or_create
      thread.post = @model.posts.last
      thread.save
    end
  end
end

class TasksController < ApplicationController
  def check_all
    render json: TaskSerializer.new(Task.all).serializable_hash
  end
end

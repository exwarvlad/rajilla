class TasksController < ApplicationController
  def check_all
    render json: TaskSerializer.new(Task.all).serializable_hash
  end

  def batch_create
    CreateBatchTasksService.new(params).call
  end

  def batch_update
    UpdateBatchTasksService.new(params).call
  end
end

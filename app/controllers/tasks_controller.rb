class TasksController < ApplicationController
  def check_all
    render json: TaskSerializer.new(Task.all).serializable_hash
  end

  def batch_create
    CreateBatchTasksService.new(params).call
  rescue ActiveRecord::RecordInvalid => e
    render json: e.message, status: 422
  ensure
    render json: '0K'
  end
end

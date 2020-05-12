class ProjectsController < ApplicationController
  def check_all
    render json: ProjectSerializer.new(Project.all).serializable_hash
  end

  def create
    CreateProjectService.new(params).call
  rescue ActionController::ParameterMissing => e
    render json: e.message, status: :bad_request
  ensure
    render json: '0K'
  end
end

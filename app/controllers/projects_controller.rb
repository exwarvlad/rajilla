class ProjectsController < ApplicationController
  def check_all
    render json: ProjectSerializer.new(Project.all).serializable_hash
  end

  def create
    ProjectService.new(params).call
  rescue ActionController::ParameterMissing => e
    render json: e, status: :bad_request
  end
end

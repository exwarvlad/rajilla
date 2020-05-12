class ProjectsController < ApplicationController
  def check_all
    render json: ProjectSerializer.new(Project.all).serializable_hash
  end
end

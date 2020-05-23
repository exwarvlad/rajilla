class TaskSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :description, :estimate_date, :price, :status, :progress, :project

  attribute :project do |object|
    ProjectSerializer.new(Project.find(object.project_id))
  end
end

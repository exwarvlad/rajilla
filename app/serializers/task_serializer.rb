class TaskSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :description, :estimate_date, :price, :urls, :project_id

  attribute :project do |object|
    ProjectSerializer.new(object.project)
  end
end

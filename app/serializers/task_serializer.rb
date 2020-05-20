class TaskSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :description, :estimate_date, :price, :urls, :project_id, :progress, :status
end

Rails.application.routes.draw do
  # projects
  get  'projects', to: 'projects#check_all'
  post 'projects', to: 'projects#create'

  # tasks
  get 'tasks', to: 'tasks#check_all'
  post 'tasks/batch_create', to: 'tasks#batch_create'
  post 'tasks/batch_update', to: 'tasks#batch_update'
end

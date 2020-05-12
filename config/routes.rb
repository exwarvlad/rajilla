Rails.application.routes.draw do
  # projects
  get  'projects', to: 'projects#check_all'
  post 'projects', to: 'projects#create'
end

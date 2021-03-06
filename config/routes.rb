# frozen_string_literal: true

Rails.application.routes.draw do
  # projects
  get  'projects', to: 'projects#check_all'
  post 'projects', to: 'projects#create'

  # tasks
  get 'tasks', to: 'tasks#check_all'
  post 'tasks/batch_create', to: 'tasks#batch_create'
  post 'tasks/batch_update', to: 'tasks#batch_update'

  # 404 not found
  match '*a', to: 'application#not_found', via: %i[get head post put delete options]
end

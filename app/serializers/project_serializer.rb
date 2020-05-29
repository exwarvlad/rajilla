# frozen_string_literal: true

class ProjectSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :description, :price

  attribute :task_count do |object|
    object.tasks.size
  end

  attribute :estimate_date do |object|
    Task.select(:estimate_date)
        .where(project_id: object)
        .order(estimate_date: :asc)
        .limit(1)
        .first
        &.estimate_date
  end

  attribute :status do |object|
    Task.select(:status)
        .where(project_id: object)
        .order(status: :asc)
        .limit(1)
        .first
        &.status
  end

  attribute :progress do |object|
    Task.select(:progress)
        .where(project_id: object)
        .order(progress: :asc)
        .limit(1)
        .first
        &.progress
  end
end

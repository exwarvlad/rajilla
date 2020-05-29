# frozen_string_literal: true

module RescueException
  extend ActiveSupport::Concern

  included do
    rescue_from ::ActiveRecord::RecordInvalid, with: :record_invalid
    rescue_from ::ActionController::ParameterMissing, with: :parameter_missing
    rescue_from ::ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from ::ActiveRecord::RecordNotUnique, with: :record_not_uniq
  end

  def record_invalid(exception)
    render json: exception.message, status: :unprocessable_entity
  end

  def not_found
    render json: '404 not found', status: :not_found
  end

  def parameter_missing(exception)
    render json: exception.message, status: :bad_request
  end

  def record_not_found(exception)
    render json: exception.message, status: :unprocessable_entity
  end

  def record_not_uniq(exception)
    render json: exception.message, status: :unprocessable_entity
  end
end

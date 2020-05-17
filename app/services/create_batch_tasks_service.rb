class CreateBatchTasksService
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def call
    Task.transaction { Task.create!(set_params) }
  end

  private

  def set_params
    params.require(:tasks).map do |task|
      task.permit(:name, :description, :estimate_date, :price, :project_id, urls: [])
    end
  end
end

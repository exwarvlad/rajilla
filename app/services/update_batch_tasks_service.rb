class UpdateBatchTasksService
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def call
    Task.transaction { Task.update(set_ids, set_params) }
  end

  def set_params
    tasks =
      params.require(:tasks).map do |task|
        task.permit(:name, :description, :estimate_date, :price, :task_id, urls: [])
      end
    tasks.each { |hash| hash.delete(:task_id) }
  end

  def set_ids
    params.require(:tasks).map { |parameters| parameters[:task_id] }
  end
end

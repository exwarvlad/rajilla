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
      params[:tasks].map do |task|
        task.permit!
      end
    tasks.each { |hash| hash.delete(:task_id) }
  end

  def set_ids
    params.require(:tasks).map { |parameters| parameters[:task_id] }
  end
end

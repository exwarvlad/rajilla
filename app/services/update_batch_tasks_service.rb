class UpdateBatchTasksService
  include RajillaWebsocketBroadcaster
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def call
    ids = set_ids
    Task.transaction { Task.update(ids, set_params) }
    broadcast(TaskSerializer.new(Task.where(id: ids)).serialized_json)
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

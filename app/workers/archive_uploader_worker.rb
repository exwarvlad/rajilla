require_relative '../../lib/razipper'

class ArchiveUploaderWorker
  include Sidekiq::Worker
  include RajillaWebsocketBroadcaster

  sidekiq_options retry: 0

  def perform(urls, task_id)
    begin
      razipper = Razipper.new(urls)
      current_task = Task.find(task_id)
      current_task.update(status: :proccesing)
      model_progress_service = ModelProgressService.new(model: current_task, limit: 50, bits_of_files: nil)

      razipper.zip(progress_service: model_progress_service)

      model_progress_service.reload_progress
      url = S3UploaderService.new(file_name: razipper.archive_name, file_path: razipper.archive_path)
                             .call(progress_service: model_progress_service)
      current_task.update(progress: 100, status: :finished)
      broadcast(url)
    rescue => e
      STDERR.puts e.message
      current_task.update(status: :failed)
    end
    razipper.remove_zip
  end
end

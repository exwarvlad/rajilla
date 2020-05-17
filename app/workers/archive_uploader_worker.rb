require_relative '../../lib/razipper'

class ArchiveUploaderWorker
  include Sidekiq::Worker

  def perform(urls)
    razipper = Razipper.new(urls)
    razipper.zip

    S3UploaderService.new(file_name: razipper.archive_name, file_path: razipper.archive_path).call
    razipper.remove_zip
  end
end

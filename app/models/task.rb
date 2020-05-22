class Task < ApplicationRecord
  include RajillaWebsocketBroadcaster

  belongs_to :project

  validates :project, presence: true
  validates :urls, presence: true
  validates :progress, inclusion: { in: 0..100, allow_blank: true }

  validate :date_biggest_or_eq_curr
  validate :price_less_or_eq_project_price
  validate :scan_urls

  after_create_commit :compile_archive_and_push_to_s3
  after_update :compile_archive_and_push_to_s3, if: proc { urls_changed? }
  after_update :report_to_tasks_notifications

  enum status: %i[initialized proccesing failed finished]

  private

  def date_biggest_or_eq_curr
    return unless estimate_date

    errors.add(:estimate_date, "can't be less then current date") if proc { estimate_date < Time.zone.today }.call
  end

  def price_less_or_eq_project_price
    return unless price

    errors.add(:price, "can't be biggest then project price") if price.to_f > project.price.to_f
  end

  def scan_urls
    errors.add(:price, "wrong urls") unless urls.all? { |url| url =~ URI::regexp }
  end

  def compile_archive_and_push_to_s3
    ArchiveUploaderWorker.perform_async(urls, id)
  end

  def report_to_tasks_notifications
    broadcast(TaskSerializer.new(self).serialized_json)
  end
end

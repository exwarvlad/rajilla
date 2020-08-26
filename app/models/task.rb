# frozen_string_literal: true

class Task < ApplicationRecord
  include RajillaWebsocketBroadcaster

  belongs_to :project

  validates :name, presence: true
  validates :project, presence: true
  validates :urls, presence: true
  validates :progress, inclusion: { in: 0..100, allow_blank: true }

  validate :date_biggest_or_eq_curr
  validate :price_less_or_eq_project_price
  validate :scan_urls
  validate :scan_content

  after_create_commit :compile_archive_and_push_to_s3
  after_update :compile_archive_and_push_to_s3, if: :urls_changed?
  after_update :report_to_tasks_notifications

  enum status: %i[initialized processing failed finished]

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
    urls.each do |url|
      errors.add(:urls, "wrong url: #{url}") unless url =~ URI::DEFAULT_PARSER.make_regexp
    end
  end

  def scan_content
    urls.each do |url|
      url = URI(url)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = (url.scheme == 'https')

      errors.add(:urls, "url: #{url} hasn't content-length") if http.request_head(url)['content-length'].to_i <= 0
    rescue StandardError
      errors.add(:urls, "can not open this url: #{url}")
    end
  end

  def compile_archive_and_push_to_s3
    ArchiveUploaderWorker.perform_async(urls, id)
  end

  def report_to_tasks_notifications
    broadcast(TaskSerializer.new(self).serialized_json)
  end
end

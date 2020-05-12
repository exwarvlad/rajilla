class Task < ApplicationRecord
  belongs_to :project

  validates :project, presence: true
  validates :urls, presence: true
  validates :progress, inclusion: { in: 0..100, allow_blank: true }

  validate :date_biggest_or_eq_curr
  validate :price_less_or_eq_project_price
  validate :scan_urls

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
end

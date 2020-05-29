# frozen_string_literal: true

project = Project.new(name: 'bum-shaka-laka-bum', price: 42.42)

5.times do |i|
  project.tasks << Task.new(name: "buy milk #{i + 1}",
                            urls: ['https://archicgi.com/wp-content/uploads/2019/12/archicgi-logotype-black.png'],
                            estimate_date: Time.zone.today + i.day)
end
project.save!

require 'net/http'
require 'open-uri'

module ConnectionValidation
  def easy_validate!(list_of_urls:, max_size: 100 * 1024 * 1024)
    current_size = 0

    list_of_urls.each do |url|
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = (url.scheme == "https")

      content_size = http.request_head(url)['content-length'].to_i
      current_size += content_size

      validate_content_length!(content_size)
      validate_content_max_size!(content_size: current_size, max_size: max_size)
    end
    true
  end

  def validate_content_max_size!(content_size:, max_size:)
    raise "files of urls can't be bigger than #{max_size} bytes" if content_size > max_size

    true
  end

  def validate_content_length!(content_size)
    raise "files of urls can't be 0 byte" if content_size.zero?

    true
  end
end

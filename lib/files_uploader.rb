require 'curb'
require_relative 'validators/connection_validation'

module FilesUploader
  include ConnectionValidation

  def grub_files_by_urls(requests, max_size)
    responses = {}
    m = Curl::Multi.new

    requests.each do |url|
      responses[url] = ""
      c = Curl::Easy.new(url.to_s) do |curl|
        curl.follow_location = true
        curl.on_body do |data|
          validate_content_length!(content_length(curl.head))
          validate_content_max_size!(content_size: (data.size + responses_size_sum(responses)), max_size: max_size)

          responses[url] << data
          data.size
        end
      end
      m.add(c)
    end
    m.perform
    responses
  end

  def responses_size_sum(responses)
    total = 0
    responses.each_value { |v| total += v.size }
    total
  end

  def content_length(head)
    return 0 unless head

    str = 'Content-Length: '
    start_index = head.index(str) || head.index('content-length: ')
    return 0 unless start_index

    start_index += (str.size - 1)

    content_size_str = ''
    (head.size - start_index).times do |i|
      break unless head[start_index + i + 1] =~ /[0-9]/

      content_size_str << head[start_index + i + 1]
    end
    content_size_str.to_i
  end
end

require 'curb'
require_relative 'validators/connection_validation'

class FilesUploader
  include ConnectionValidation

  attr_reader :requests, :max_size, :responses

  def initialize(requests, max_size)
    @requests = requests
    @max_size = max_size
    @current_size = 0
    @responses = {}
    @multi = Curl::Multi.new
  end

  def grub_files_by_urls(model_progress_service)
    requests.each do |url|
      url = url.to_s
      responses[url] = ""
      c = Curl::Easy.new(url) do |curl|
        curl.follow_location = true
        curl.on_body do |data|
          validate!(url: url, head: curl.head)

          responses[url] << data
          model_progress_service.update(bit: url, data_size: data.size, bit_length: @file_length)
          @current_size += data.size
          data.size
        end

        curl.on_success do |data|
          resp_size = responses[data.url].size
          validate_compliance!(expecting: @file_length,
                               reality: resp_size,
                               message: "content-length (#{@file_length}) doesn't compliance response size (#{resp_size})")
        end
      end
      multi.add(c)
    end
    multi.perform
    responses
  end

  private

  attr_accessor :multi, :responses

  def validate!(url:, head:)
    @file_length = content_length(head)
    validate_content_length!(@file_length)
    validate_content_max_size!(content_size: @current_size, max_size: max_size)
    validate_content_max_size!(content_size: responses[url].size, max_size: @file_length)
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

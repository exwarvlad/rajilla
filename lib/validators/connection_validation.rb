# frozen_string_literal: true

require 'net/http'
require 'open-uri'

module ConnectionValidation
  def easy_validate!(bit_of_files:, max_size: 100 * 1024 * 1024)
    content_size = 0
    bit_of_files.each_value do |v|
      validate_content_length!(v)
      content_size += v
    end

    validate_content_max_size!(content_size: content_size, max_size: max_size)
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

  def validate_compliance!(expecting:, reality:, message: "expecting doesn't compliance reality")
    raise message unless expecting == reality

    true
  end
end

require 'zip'
require 'open-uri'
require 'fileutils'
require 'active_support/core_ext'
require_relative 'validators/connection_validation'
require_relative 'files_uploader'

class Razipper
  include ConnectionValidation

  attr_reader :list_of_urls, :archive_folder, :archive_path, :archive_name

  def initialize(list_of_urls)
    @list_of_urls = list_of_urls.map { |url| URI(url) }
  end

  def zip(name: 'archive', limit_files_size: 100 * 1024 * 1024, progress_service: nil)
    easy_validate!(bit_of_files: bit_of_files, max_size: limit_files_size)
    progress_service.bits_of_files = bit_of_files if progress_service

    files_uploader = FilesUploader.new(list_of_urls, limit_files_size)
    responses = files_uploader.grub_files_by_urls(progress_service)

    @archive_path = generate_uniq_tmp_folder + '/' + name + '.zip'
    @archive_name = name

    Zip::ZipOutputStream.open(archive_path) do |zio|
      list_of_urls.each_with_index do |url, i|
        file_name = "#{i + 1}_" << grub_file_name_from_path(url.path)

        zio.put_next_entry(file_name)
        zio.print(responses.delete(url.to_s))
      end
    end
    archive_path
  end

  def remove_zip
    return unless archive_folder
    FileUtils.remove_dir(archive_folder) if File.directory?(archive_folder)
  end

  private

  def bit_of_files
    hash = {}
    list_of_urls.each do |url|
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = (url.scheme == "https")

      hash[url.to_s] = http.request_head(url)['content-length'].to_i
    end
    hash
  end

  def generate_uniq_tmp_folder
    @archive_folder = FileUtils.mkdir_p("#{Dir.pwd}/tmp/#{SecureRandom.hex(5)}")[0]
  end

  def grub_file_name_from_path(path)
    path.chomp!('/') while path[-1] == '/'
    last_slash_index = 0

    path.size.times { |i| break last_slash_index = -(i + 1) if path[-(i + 1)] == '/' }
    path[last_slash_index + 1..-1]
  end
end

require 'zip'
require 'open-uri'
require 'fileutils'
require 'active_support/core_ext'
require_relative 'validators/connection_validation'
require_relative 'files_uploader'

class Razipper
  include ConnectionValidation
  include FilesUploader

  attr_reader :list_of_urls, :archive_folder, :archive_path

  def initialize(list_of_urls)
    @list_of_urls = list_of_urls.map { |url| URI(url) }
  end

  def zip(name: 'archive', limit_files_size: 100 * 1024 * 1024)
    easy_validate!(list_of_urls: list_of_urls, max_size: limit_files_size)
    responses = grub_files_by_urls(list_of_urls, limit_files_size)
    @archive_path = generate_uniq_tmp_folder + '/' + name + '.zip'

    Zip::ZipOutputStream.open(archive_path) do |zio|
      list_of_urls.each_with_index do |url, i|
        file_name = "#{i + 1}_" << grub_file_name_from_path(url.path)

        zio.put_next_entry(file_name)
        zio.print(responses.delete(url))
      end
    end
    archive_path
  end

  def remove_zip
    FileUtils.remove_dir(archive_path) if File.directory?(archive_path)
  end

  private

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

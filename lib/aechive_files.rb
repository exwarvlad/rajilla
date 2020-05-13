require 'zip'
require 'open-uri'
require 'fileutils'
require 'active_support/core_ext'

class Razipper
  attr_reader :list_of_files, :archive_folder, :archive_file

  def initialize(list_of_files)
    @list_of_files = list_of_files.map { |url| URI(url) }
  end

  def zip(name: 'archive')
    archive_file = generate_uniq_tmp_folder + '/' + name + '.zip'

    Zip::ZipOutputStream.open(archive_file) do |zio|
      list_of_files.each do |uri|
        file_name = grub_file_name_from_path(uri.path)

        zio.put_next_entry(file_name)
        zio.print(open(uri).read)
      end
    end
    archive_file
  end

  def remove_zip
    FileUtils.remove_dir(archive_folder) if File.directory?(archive_folder)
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

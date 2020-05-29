class S3UploaderService
  attr_reader :file_name, :file_path, :s3, :file_size

  def initialize(file_name:, file_path:)
    @file_name = file_name
    @file_path = file_path
    @s3 = Aws::S3::Client.new
    @file_size = File.size(file_path)
  end

  def call(progress_service: nil, model: nil)
    progress_service.bits_of_files = {zip: file_size} if progress_service
    s3_resource = Aws::S3::Resource.new(region:'us-west-2')
    obj = s3_resource.bucket(ENV['S3_BUCKET']).object(SecureRandom.hex(5) + '_' + file_name)

    obj.upload_stream(content_length: file_size, acl: 'public-read') do |buffer|
      File.open(file_path, 'rb', encoding: "bom|utf-8").each(nil, file_size / 50) do |chunk|
        buffer.write(chunk)
        progress_service.update(bit: file_size, data_size: chunk.size, bit_length: file_size) if progress_service
      end
    end
    model.update(archive_public_url: obj.public_url) if model
    obj.public_url
  end
end

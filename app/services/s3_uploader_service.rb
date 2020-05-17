class S3UploaderService
  attr_reader :file_name, :file_path, :s3

  BUCKET = "#{Rails.env}-rajilla-archives".freeze

  def initialize(file_name:, file_path:)
    @file_name = file_name
    @file_path = file_path
    @s3 = Aws::S3::Client.new
  end

  def call
    s3_resource = Aws::S3::Resource.new(region:'us-west-2')
    obj = s3_resource.bucket(find_or_create_bucket).object(SecureRandom.hex(5) + '_' + file_name)
    obj.upload_file(file_path)
  end

  private

  def find_or_create_bucket
    bucket = s3.list_buckets.buckets.map(&:name).include?(BUCKET)
    s3.create_bucket(bucket: BUCKET) unless bucket
    BUCKET
  end
end

class ModelProgressService
  attr_reader :model
  attr_accessor :limit, :bits_of_files

  def initialize(model:, limit:, bits_of_files:)
    @model = model
    @limit = limit
    @progress = model.progress
    @bits_of_files = bits_of_files
    @inbox_size = 0
  end

  def update(bit:, data_size:, bit_length:)
    bits_of_files[bit] = bit_length
    progress_rate = bits_of_files_size_sum.to_f / limit
    @inbox_size += data_size

    @additional_progress = (@inbox_size / progress_rate).round + @progress
    model.update!(progress: @additional_progress) if @additional_progress > @prev_progress.to_i

    @prev_progress = @additional_progress
    @additional_progress
  end

  def reload_progress
    @progress = model.reload.progress
  end

  private

  def bits_of_files_size_sum
    total = 0
    @bits_of_files.each_value { |v| total += v }
    total
  end
end

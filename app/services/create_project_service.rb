class CreateProjectService
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def call
    Project.create!(set_params)
  end

  private

  def set_params
    params.require(:project).permit(:name, :description, :price)
  end
end

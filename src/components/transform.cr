class Glove::Components::Transform < Glove::Component
  property :width
  property :height
  property :translate_x
  property :translate_y
  property :angle
  property :scale_x
  property :scale_y
  property :anchor_x
  property :anchor_y

  @model_matrix : Glove::GLM::TMat4(Float32)

  def initialize
    @width = 0_f32
    @height = 0_f32
    @translate_x = 0_f32
    @translate_y = 0_f32
    @angle = 0.0_f32
    @scale_x = 1_f32
    @scale_y = 1_f32
    @anchor_x = 0.5_f32
    @anchor_y = 0.5_f32

    @model_matrix = Glove::GLM::Mat4.identity
  end

  def matrix
    Glove::GLM.identity(@model_matrix)
    Glove::GLM.translate(@model_matrix, @translate_x, @translate_y)
    Glove::GLM.rotate_z(@model_matrix, @angle)
    Glove::GLM.scale(@model_matrix, @width * @scale_x, @height * @scale_y)
    Glove::GLM.translate(@model_matrix, -@anchor_x, -@anchor_y)

    @model_matrix
  end

  def bounds
    m = matrix

    points = [
      m.transform(0_f32, 0_f32),
      m.transform(0_f32, 1_f32),
      m.transform(1_f32, 0_f32),
      m.transform(1_f32, 1_f32),
    ]

    min_x = points.map { |po| po[0] }.min
    min_y = points.map { |po| po[1] }.min
    max_x = points.map { |po| po[0] }.max
    max_y = points.map { |po| po[1] }.max

    origin = Glove::Point.new(min_x, min_y)
    size = Glove::Size.new(max_x - min_x, max_y - min_y)
    Glove::Rect.new(origin, size)
  end
end

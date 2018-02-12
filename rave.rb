require_relative 'env'

while true
  @lamps.each do |lamp|
    colors = @colors - lamp.color
    lamp.color = colors.sample
    @hue.change!(lamp)
    sleep 0.1
  end
end


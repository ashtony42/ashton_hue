require_relative 'env'

while true
  @lamps.each do |lamp|
    lamp.color = @colors.sample
    @hue.change!(lamp)
    sleep 0.1
  end
end


require_relative 'env'

@lamps.each do |lamp|
  lamp.saturation = 0
  @hue.change!(lamp)
end

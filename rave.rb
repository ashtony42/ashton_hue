require_relative 'env'

lamp_and_color = @lamps.map{|lamp| {:lamp => lamp, :color => @colors.sample} }

while true
  lamp_and_color.each do |l_and_c|
    new_color = (@colors - [l_and_c[:color]]).sample
    l_and_c[:lamp].color = new_color
    l_and_c[:color] = new_color
    @hue.change!(l_and_c[:lamp])
    sleep 0.1
  end
end


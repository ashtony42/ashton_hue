require 'yaml'
require 'test_driven_lighting'

config = YAML.load_file('config.yml')
hue = Hue.new config
lamps = [Lamp.new(1), Lamp.new(2), Lamp.new(3)]
colors = lamps[1].colors.map{|color| color[0]}

while true
  lamps.each do |lamp|
    lamp.color = colors.sample
    hue.change!(lamp)
    sleep 0.1
  end
end


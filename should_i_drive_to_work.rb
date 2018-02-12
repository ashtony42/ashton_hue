require 'net/http'
require 'json'
require_relative 'env'

home_address = @config[:home_address]
destination_address = @config[:destination_address]
api_key = @config[:google_maps_api_key]
uri = URI("https://maps.googleapis.com/maps/api/directions/json?units=imperial&origin=#{home_address}&destination=#{destination_address}&key=#{api_key}&departure_time=now")
distance_data = JSON.parse(Net::HTTP.get(uri))
time_to_get_to_work = distance_data['routes'][0]['legs'][0]['duration_in_traffic']['text'].split(' ')[0].to_i

color = nil
if time_to_get_to_work < 30
  color = 'green'
  puts "Get out there bro! It should only take #{time_to_get_to_work} minutes!"
elsif time_to_get_to_work < 45
  color = 'yellow'
  puts "Eh, it may take a while longer, but still worth it, might take about #{time_to_get_to_work} minutes."
else color = 'red'
  puts "Dude, just stay home, it's not worth the #{time_to_get_to_work} minute drive."
end

@lamps.each do |lamp|
  lamp.color = color
  @hue.change!(lamp)
end


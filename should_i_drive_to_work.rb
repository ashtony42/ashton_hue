require 'net/http'
require 'json'
require_relative 'env'

home_address = @config[:home_address]
destination_address = @config[:destination_address]
api_key = @config[:google_maps_api_key]
uri = URI("https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=#{home_address}&destinations=#{destination_address}&key=#{api_key}")
distance_data = JSON.parse(Net::HTTP.get(uri))
time_to_get_to_work = distance_data['rows'][0]['elements'][0]['duration']['text'].split(' ')[0].to_i

color = nil
if time_to_get_to_work < 30
  color = 'green'
elsif time_to_get_to_work < 45
  color = 'yellow'
else color = 'red'
end

@lamps.each do |lamp|
  lamp.color = color
  @hue.change!(lamp)
end


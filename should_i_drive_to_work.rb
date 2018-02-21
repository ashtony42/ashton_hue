require 'net/http'
require 'json'
require 'rufus-scheduler'
require_relative 'env'

LAMP = @lamps[3]
ENV['TZ'] = 'America/New_York'

#Lamp reset
LAMP.is_on = false
@hue.change!(LAMP)

def log text
  File.open('cron_log.log', 'a'){|f| f.puts("#{Time.now} - #{text}")}
end

def time_to_get_to_work
  home_address = @config[:home_address]
  destination_address = @config[:destination_address]
  api_key = @config[:google_maps_api_key]
  uri = URI("https://maps.googleapis.com/maps/api/directions/json?units=imperial&origin=#{home_address}&destination=#{destination_address}&key=#{api_key}&departure_time=now")

  distance_data = JSON.parse(Net::HTTP.get(uri))
  distance_data['routes'][0]['legs'][0]['duration_in_traffic']['text'].split(' ')[0].to_i
end

scheduler = Rufus::Scheduler.new
scheduler.cron '30,40,50 7,8 * * 1,2,3,4,5' do  # check at 7:30/7:40/7:50 every weekday
  begin
    if Time.now.hour == 8
      LAMP.is_on = false #Turn itself off at 8:30
    else
      LAMP.is_on = true #Turn itself on at 7:30
      minutes = time_to_get_to_work
      case minutes
        when 0..30
          LAMP.color = 'green'
          log("Get out there! It should only take #{minutes} minutes!")
        when 31..45
          LAMP.color = 'yellow'
          log("Eh, it may take a while longer, but still worth it, might take about #{minutes} minutes.")
        else
          LAMP.color = 'red'
          log("Dude, just stay home, it's not worth the #{minutes} minute drive.")
      end
    end
    @hue.change!(LAMP)
  rescue => e
    log("#{e.message}\n#{e.backtrace}")
  end
end
puts 'running should_i_drive_to_work scheduler...'
scheduler.join





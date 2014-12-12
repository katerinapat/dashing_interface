require 'net/https'
require 'json'

# Forecast API Key from https://developer.forecast.io
forecast_api_key = "a0992271e8767037752b361153af2b21"

# Latitude, Longitude for  Brno
forecast_location_lat = "49.19106"
forecast_location_long = "16.611419"

#Heraklion
forecast_location_lat_her = "35.3333333333"
forecast_location_long_her = "25.1333333333"

# Unit Format
# "us" - U.S. Imperial
# "si" - International System of Units
# "uk" - SI w. windSpeed in mph
forecast_units = "si"
  
SCHEDULER.every '5m', :first_in => 0 do |job|
  http = Net::HTTP.new("api.forecast.io", 443)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_PEER

  response = http.request(Net::HTTP::Get.new("/forecast/#{forecast_api_key}/#{forecast_location_lat},#{forecast_location_long}?units=#{forecast_units}"))
  forecast = JSON.parse(response.body) 

  
  puts "this is the response #{response}"
  puts "this is the parse response #{forecast}"


  forecast_current_temp = forecast["currently"]["temperature"].round
  forecast_current_icon = forecast["currently"]["icon"]
  forecast_current_desc = forecast["currently"]["summary"]
 
  forecast_later_desc   = forecast["hourly"]["summary"]
  forecast_later_icon   = forecast["hourly"]["icon"]

  #Heraklion
  response_her = http.request(Net::HTTP::Get.new("/forecast/#{forecast_api_key}/#{forecast_location_lat_her},#{forecast_location_long_her}?units=#{forecast_units}"))
  forecast_her = JSON.parse(response_her.body)  
  forecast_current_temp_her = forecast_her["currently"]["temperature"].round
  forecast_current_icon_her = forecast_her["currently"]["icon"]
  forecast_current_desc_her = forecast_her["currently"]["summary"]
 
  forecast_later_desc_her   = forecast_her["hourly"]["summary"]
  forecast_later_icon_her   = forecast_her["hourly"]["icon"]
  send_event('forecast_her', { city: "Heraklion", current_temp: "#{forecast_current_temp_her}&deg;", current_icon: "#{forecast_current_icon_her}", current_desc: "#{forecast_current_desc}", later_icon: "#{forecast_later_icon_her}", later_desc: "#{forecast_later_desc_her}"})
  send_event('forecast', { city: "Brno", current_temp: "#{forecast_current_temp}&deg;", current_icon: "#{forecast_current_icon}", current_desc: "#{forecast_current_desc}", later_icon: "#{forecast_later_icon}", later_desc: "#{forecast_later_desc}"})
 end
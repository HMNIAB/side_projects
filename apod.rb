#!/usr/bin/env/ruby

# frozen_string_literal: true

require 'date'
require 'httparty'
require 'json'

# You need to go to the NASA API site to get your API key.
# https://api.nasa.gov/#signUp
APOD_API_KEY = nil
start_date = Date.new(2024, 1, 1)
# TODAY = Date.today # ('%Y-%m-%d')

while start_date <= Date.today
  # date_string = current_date.strftime('%Y-%m-%d')
  date_string = start_date.strftime('%Y-%m-%d')
  response = HTTParty.get("https://api.nasa.gov/planetary/apod?api_key=#{APOD_API_KEY}&date=#{date_string}&concept_tags=False")

  if response.success?
    data = JSON.parse(response.body)

    # Check if it is an image (sometimes APOD is a video)
    if data['media_type'] == 'image'
      image_url = data['hdurl']

      # Download the image
      image_data = HTTParty.get(image_url).body

      # Create safe filename from title
      filename = data['title'].gsub(/[\/\\:*?"<>| ]/, '_')
      extension = File.extname(image_url)
      filename = "#{filename}#{extension}"

      File.open(filename, 'wb') do |file|
        file.write(image_data)
      end
    end
  end
  puts "#{filename} downloaded successfully!"
  start_date += 1
end

puts "Stopped at date: #{start_date}"
puts 'Saving this date to continue later in file .resume_date'
File.write('.resume_date', stat_date.to_s)

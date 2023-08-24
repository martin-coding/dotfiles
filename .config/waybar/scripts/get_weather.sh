#!/usr/bin/env bash
# get_weather.sh

# API-Call for weather data
API_ENDPOINT="https://api.openweathermap.org/data/2.5/weather"

# API-Key for OpenWeatherMap (from environment variable)
API_KEY="$OPENWEATHERMAP_API_KEY"

# Wether location (from environment variables)
LATITUDE="$WEATHER_LATITUDE"
LONGITUDE="$WEATHER_LONGITUDE"

# Select system language (for API call)
locale="$LANG"
language="${locale%%_*}"

# Check if API-Key is set
if [[ -z "$API_KEY" ]]; then
  echo "{\"text\": \" err\", \"tooltip\": \"Error: No API-Key set\"}"
  exit 0
fi
# Check if coordinates are set
if [[ -z "$LATITUDE" || -z "$LONGITUDE" ]]; then
  echo "{\"text\": \" err\", \"tooltip\": \"Error: No coords set\"}"
  exit 0
fi

# Send API request and get response
response=$(curl -s "${API_ENDPOINT}?lat=${LATITUDE}&lon=${LONGITUDE}&units=metric&lang=${language}&appid=${API_KEY}")

# Process and output JSON data
if [[ -n "$response" ]]; then
  temperature=$(echo "$response" | jq -r '.main.temp')
  temp_max=$(echo "$response" | jq -r '.main.temp_max')
  conditions=$(echo "$response" | jq -r '.weather[0].description')
  pressure=$(echo "$response" | jq -r '.main.pressure')
  humidity=$(echo "$response" | jq -r '.main.humidity')
  windspeed=$(echo "$response" | jq -r '.wind.speed')
  winddirection=$(echo "$response" | jq -r '.wind.deg')
  echo "{\"text\": \" $temperature°C\", \"tooltip\": \"$conditions (max: $temp_max°C)\n\nPressure:\t$pressure hPa\nHumidity:\t\t$humidity %\nWind:\t\t$windspeed m/s ($winddirection°)\"}"
else
  echo "{\"text\": \" err\", \"tooltip\": \"Error: No response\"}"
fi

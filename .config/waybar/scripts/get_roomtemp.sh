#!/usr/bin/env bash
# get_roomtemp.sh

# Request url
REQ_URL="http://192.168.178.241"

# Send request and receive response
response=$(curl -s "${REQ_URL}")

# JSON-Daten verarbeiten und ausgeben
if [[ -n "$response" ]]; then
  temperature=$(echo "$response" | jq -r '.temperature')
  humidity=$(echo "$response" | jq -r '.humidity')
  echo "{\"text\": \" $temperature°C\", \"tooltip\": \"Humidity:\t$humidity%\"}"
else
  echo "{\"text\": \" err\", \"tooltip\": \"Error: No response\"}"
fi

# frozen_string_literal: true

# Spreadsheet courtesy of the A List Apart 2010 Web Design Survey:
# http://www.alistapart.com/articles/survey2010

require 'roo'
require 'pry'
require 'byebug'

cdr = Roo::Spreadsheet.open('./7712607269_2.xlsx')

# Create a hash of the headers so we can access columns by name (assuming row
# 1 contains the column headings).  This will also grab any data in hidden
# columns.
headers = []
rows = []
# if row.length < 5
range = cdr.first_row..cdr.last_row
cdr.parse[range].each_with_index do |row, idx|
  next unless row.reject(&:nil?).length > 4

  modified_row = row
  byebug
  idx == 1 ? headers << row : rows << modified_row
end

headers = headers[0].map { |header| header.downcase.strip.gsub('.', '').gsub(' ', '_') }

headers << 'timestamp' << 'timestamp_value'

# check headers to make sure latlong are properly placed
CSV.open('kepler.csv', 'w', headers: headers, write_headers: true) do |csv|
  rows.each_with_index do |row, idx|
    p idx
    telefono = row[0]
    tipo = row[1]
    numero_a = row[2]
    numero_b = row[3]
    fecha = row[4].strftime('%Y-%m-%d')
    hora = Time.at(row[5]).utc.strftime('%H:%M:%S')
    merged_date = "#{fecha} #{hora} -06:00"
    timestamp_value = DateTime.strptime(merged_date, '%Y-%m-%d %H:%M:%S %:z').to_time
    p timestamp_value
    timestamp = timestamp_value.to_i
    durac_seg = row[6]
    latitude = row[7]
    longitude = row[8]
    next unless latitude.split('').length > 3 && longitude.split('').length > 3

    lat_deg = latitude.split('°')[0].to_f
    lat_min = latitude.split('°')[1].split('\'')[0].to_f / 60
    lat_sec = latitude.split('°')[1].split('\'')[1].gsub('"N', '').to_f / 3600
    lng_deg = "-#{longitude.split('°')[0]}".to_f
    lng_min = "-#{longitude.split('°')[1].split('\'')[0]}".to_f / 60
    lng_sec = "-#{longitude.split('°')[1].split('\'')[1].gsub('"W', '')}".to_f / 3600
    latitude = lat_deg + lat_min + lat_sec
    longitude = lng_deg + lng_min + lng_sec
    # lat_deg, lat_min, lat_sec = 'something'
    azimuth = row[9]
    csv_row = [telefono, tipo, numero_a, numero_b, fecha, hora, durac_seg, latitude, longitude, azimuth]
    csv_row << timestamp << timestamp_value unless fecha.nil? || hora.nil?
    csv << csv_row
  end
end
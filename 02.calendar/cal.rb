#!/usr/bin/env ruby
require 'date'
require 'optparse'

today = Date.today
today_year = today.year
today_month = today.month

puts "#{today_month}月" " " "#{today_year}".center(20)
puts "日 " "月 " "火 " "水 " "木 " "金 " "土 "

params = ARGV.getopts("y:m:")

if params["y"] == nil
  year = today_year
else
  year = params["y"].to_i
end

if params["m"] == nil
  month = today_month
else
  month = params["m"].to_i
end

#カレンダーを表示させる
first_day = Date.new(year, month, 1)
last_day = Date.new(year, month, -1)
print "   " * first_day.wday

(1..last_day.day).each do |number|
 day = Date.new(year, month, number)
 wday = day.wday

 if wday == 6
    puts number.to_s.rjust(2) + " "
 else
    print number.to_s.rjust(2) + " "
 end
end
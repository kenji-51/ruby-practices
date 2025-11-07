#!/usr/bin/env ruby
require 'date'
require 'optparse'
require 'debug'

today = Date.today
today_year = today.year
today_month = today.month
params = ARGV.getopts("y:m:")

if params["y"] && params["m"]
  puts "#{params["m"]}月 #{params["y"]}".center(20)
elsif params["m"]
  puts "#{params["m"]}月 #{today_year}".center(20)
else
  puts "#{today_month}月" " " "#{today_year}".center(20)
end

puts "日 月 火 水 木 金 土"

if params["y"].nil?
  year = today_year
else
  year = params["y"].to_i
end

if params["m"].nil?
  month = today_month
else
  month = params["m"].to_i
end

#カレンダーを表示させる
first_date = Date.new(year, month, 1)
last_date = Date.new(year, month, -1)
print "   " * first_date.wday

(first_date..last_date).each do |date|
  day_display = date.day.to_s.rjust(2) 

  if date.saturday?
    puts day_display
  else
    print day_display + " " 
  end
end

#!/usr/bin/env ruby
require 'date'
require 'optparse'

today = Date.today
today_year = today.year
today_month = today.month
params = ARGV.getopts("y:m:")

year = params["y"].nil? ? today_year : params["y"].to_i
month = params["m"].nil? ? today_month : params["m"].to_i

puts "#{month}月  #{year}".center(20) 
puts "日 月 火 水 木 金 土"

first_date = Date.new(year, month, 1)
last_date = Date.new(year, month, -1)
print "   " * first_date.wday

(first_date..last_date).each do |date|
  day = date.day.to_s.rjust(2) 

  if date.saturday?
    puts day
  else
    print day + " " 
  end
end

#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = scores.flat_map do |run|
  run == 'X' ? [10, 0] : run.to_i
end

frames = shots.each_slice(2).to_a

points = frames.each_with_index.sum do |frame, index|

frames.each_with_index.sum do |frame, index|
  point += case index
           when 0..8
             if frames[index][0] == 10
               if frames[index + 1][0] == 10
                 10 + frames[index + 1][0] + frames[index + 2][0]
               else
                 10 + frames[index + 1].sum
               end
             elsif frame.sum == 10
               10 + frames[index + 1][0]
             else
               frames[index].sum
             end
           else
             frame.sum
           end
end

puts point

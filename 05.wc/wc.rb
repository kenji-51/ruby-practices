# frozen_string_literal: true

require 'optparse'

l_cmd = false
w_cmd = false
c_cmd = false

OptionParser.new do |opt|
  opt.on('-l') { l_cmd = true }
  opt.on('-w') { w_cmd = true }
  opt.on('-c') { c_cmd = true }
  opt.parse!(ARGV)
end

files = ARGV
files_count = files.size

if files.empty?
  input = $stdin.read

  number_of_lines = input.lines.length
  word_counts = input.split.length
  number_of_bytes = input.bytesize

  output_counts = []

  output_counts << number_of_lines.to_s.rjust(6) if l_cmd
  output_counts << word_counts.to_s.rjust(6) if w_cmd
  output_counts << number_of_bytes.to_s.rjust(6) if c_cmd

  unless l_cmd || w_cmd || c_cmd
    output_counts << number_of_lines.to_s.rjust(6)
    output_counts << word_counts.to_s.rjust(6)
    output_counts << number_of_bytes.to_s.rjust(6)
  end

  puts output_counts.join

else

  total_file_number_of_lines = 0
  total_file_word_counts = 0
  total_file_number_of_bytes = 0

  result = files.map do |file|
    reading_file = File.read(file)

    file_number_of_lines = reading_file.lines.length
    file_word_counts = reading_file.split.length
    file_number_of_bytes = reading_file.bytesize

    total_file_number_of_lines += file_number_of_lines
    total_file_word_counts += file_word_counts
    total_file_number_of_bytes += file_number_of_bytes

    output_counts = []

    output_counts << file_number_of_lines.to_s.rjust(6) if l_cmd
    output_counts << file_word_counts.to_s.rjust(6) if w_cmd
    output_counts << file_number_of_bytes.to_s.rjust(6) if c_cmd

    unless l_cmd || w_cmd || c_cmd
      output_counts << file_number_of_lines.to_s.rjust(6)
      output_counts << file_word_counts.to_s.rjust(6)
      output_counts << file_number_of_bytes.to_s.rjust(6)
    end
    output_counts.join + " #{file}"
  end

  puts result

  if files_count > 1
    output_counts = []

    output_counts << total_file_number_of_lines.to_s.rjust(6) if l_cmd
    output_counts << total_file_word_counts.to_s.rjust(6) if w_cmd
    output_counts << total_file_number_of_bytes.to_s.rjust(6) if c_cmd

    unless l_cmd || w_cmd || c_cmd
      output_counts << total_file_number_of_lines.to_s.rjust(6)
      output_counts << total_file_word_counts.to_s.rjust(6)
      output_counts << total_file_number_of_bytes.to_s.rjust(6)
    end

    puts "#{output_counts.join} total"
  end
end

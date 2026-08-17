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

  multiple_options = []

  multiple_options << number_of_lines.to_s.rjust(6) if l_cmd
  multiple_options << word_counts.to_s.rjust(6) if w_cmd
  multiple_options << number_of_bytes.to_s.rjust(6) if c_cmd

  unless l_cmd || w_cmd || c_cmd
    multiple_options << number_of_lines.to_s.rjust(6)
    multiple_options << word_counts.to_s.rjust(6)
    multiple_options << number_of_bytes.to_s.rjust(6)
  end

  puts multiple_options.join

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

    multiple_options = []

    multiple_options << file_number_of_lines.to_s.rjust(6) if l_cmd
    multiple_options << file_word_counts.to_s.rjust(6) if w_cmd
    multiple_options << file_number_of_bytes.to_s.rjust(6) if c_cmd

    unless l_cmd || w_cmd || c_cmd
      multiple_options << file_number_of_lines.to_s.rjust(6)
      multiple_options << file_word_counts.to_s.rjust(6)
      multiple_options << file_number_of_bytes.to_s.rjust(6)
    end
    multiple_options.join + " #{file}"
  end

  puts result

  if files_count > 1
    total_options = []

    total_options << total_file_number_of_lines.to_s.rjust(6) if l_cmd
    total_options << total_file_word_counts.to_s.rjust(6) if w_cmd
    total_options << total_file_number_of_bytes.to_s.rjust(6) if c_cmd

    unless l_cmd || w_cmd || c_cmd
      total_options << total_file_number_of_lines.to_s.rjust(6)
      total_options << total_file_word_counts.to_s.rjust(6)
      total_options << total_file_number_of_bytes.to_s.rjust(6)
    end

    puts "#{total_options.join} total"
  end
end

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

def count_input_data(input_data)
  lines = input_data.lines.length
  words = input_data.split.length
  bytes = input_data.bytesize

  { lines:, words:, bytes: }
end

def format_counts(counts, l_cmd, w_cmd, c_cmd)
  output_counts = []

  options = {
    lines: l_cmd,
    words: w_cmd,
    bytes: c_cmd
  }

  no_option = !l_cmd && !w_cmd && !c_cmd

  options.each do |key, value|
    output_counts << counts[key].to_s.rjust(6) if value || no_option
  end

  output_counts.join
end

if files.empty?
  input_data = $stdin.read

  counts = count_input_data(input_data)
  output = format_counts(counts, l_cmd, w_cmd, c_cmd)

  puts output
else
  total_lines = 0
  total_words = 0
  total_bytes = 0

  files.each do |file|
    input_data = File.read(file)

    counts = count_input_data(input_data)

    total_lines += counts[:lines]
    total_words += counts[:words]
    total_bytes += counts[:bytes]

    output = format_counts(counts, l_cmd, w_cmd, c_cmd)

    puts "#{output} #{file}"
  end

  if files.size > 1
    total_counts = {
      lines: total_lines,
      words: total_words,
      bytes: total_bytes
    }

    total_output = format_counts(total_counts, l_cmd, w_cmd, c_cmd)

    puts "#{total_output} total"
  end
end

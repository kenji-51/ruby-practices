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

  if !l_cmd && !w_cmd && !c_cmd
    options[:lines] = true
    options[:words] = true
    options[:bytes] = true
  end

  options.each do |key, value|
    output_counts << counts[key].to_s.rjust(6) if value
  end

  output_counts.join
end

if files.empty?
  input_data = $stdin.read

  counts = count_input_data(input_data)
  output = format_counts(counts, l_cmd, w_cmd, c_cmd)

  puts output
else
  total_counts = {
    lines: 0,
    words: 0,
    bytes: 0
  }
  files.each do |file|
    input_data = File.read(file)
    counts = count_input_data(input_data)

    total_counts[:lines] += counts[:lines]
    total_counts[:words] += counts[:words]
    total_counts[:bytes] += counts[:bytes]

    output = format_counts(counts, l_cmd, w_cmd, c_cmd)

    puts "#{output} #{file}"
  end

  if files.size > 1
    total_output = format_counts(total_counts, l_cmd, w_cmd, c_cmd)

    puts "#{total_output} total"
  end
end

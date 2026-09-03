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

  options = options.transform_values { true } if options.values.none?

  output_counts << counts[:lines].to_s.rjust(6) if options[:lines]
  output_counts << counts[:words].to_s.rjust(6) if options[:words]
  output_counts << counts[:bytes].to_s.rjust(6) if options[:bytes]

  output_counts.join(' ')
end

def output_counts(counts, l_cmd, w_cmd, c_cmd, name)
  output = format_counts(counts, l_cmd, w_cmd, c_cmd)
  puts "#{output} #{name}"
end

if files.empty?
  input_data = $stdin.read
  counts = count_input_data(input_data)

  puts format_counts(counts, l_cmd, w_cmd, c_cmd)
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

    output_counts(counts, l_cmd, w_cmd, c_cmd, file)
  end

  output_counts(total_counts, l_cmd, w_cmd, c_cmd, 'total') if files.size > 1
end

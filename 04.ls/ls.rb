# frozen_string_literal: true

def build_file_names(files, cols)
  number_of_files = files.length
  rows = (number_of_files.to_f / cols).ceil

  nested_array = Array.new(rows) { Array.new(cols) }

  rows.times do |row|
    cols.times do |col|
      idx = (rows * col) + row
      nested_array[row][col] = files[idx]
    end
  end

  nested_array
end

def make_max_width(file_names)
  max_width = 0

  file_names.each do |row|
    row.each do |file|
      next if file.nil?

      max_width = file.length if file.length > max_width
    end
  end

  max_width
end

def display_file_names(file_names, max_width)
  file_names.each do |row|
    row.each do |file|
      file = '' if file.nil?

      print file.ljust(max_width + 3)
    end
    puts
  end
end

FILES = Dir.glob('*')
COLS = 3

file_names = build_file_names(FILES, COLS)
max_width = make_max_width(file_names)
display_file_names(file_names, max_width)

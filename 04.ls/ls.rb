# frozen_string_literal: true

def show_current_dirs
  Dir.glob('*')
end

def make_double_array(files, cols)
  number_of_files = files.length
  rows = (number_of_files.to_f / cols).ceil

  double_arr = Array.new(rows) { Array.new(cols) }

  rows.times do |row|
    cols.times do |col|
      idx = (rows * col) + row
      double_arr[row][col] = files[idx]
    end
  end

  double_arr
end

def make_max_width(double_arr)
  max_width = 0

  double_arr.each do |row|
    file = row[0]
    next if file.nil?

    max_width = file.length if file.length > max_width
  end

  max_width
end

def display_result(double_arr, max_width)
  double_arr.each do |row|
    row.each_with_index do |file, col|
      file = '' if file.nil?
      print col.zero? ? file.ljust(max_width + 3) : file.ljust(20)
    end
    puts
  end
end

files = show_current_dirs
cols = 3

double_arr = make_double_array(files, cols)
max_width = make_max_width(double_arr)
display_result(double_arr, max_width)

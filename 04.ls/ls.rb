# frozen_string_literal: true

require 'optparse'
require 'etc'

COLS = 3

list_cmd = false

OptionParser.new do |opt|
  opt.on('-l') { list_cmd = true }
  opt.parse(ARGV)
end

files = Dir.glob('*')

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

# メソッド
if list_cmd
  file_type_hash = {
    '1' => '-',
    '4' => 'd'
  }

  permission_hash = {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }

  max_size_width = files.map { |file| File.stat(file).size.to_s.length }.max

  total_blocks = 0

  def make_file_mode_structure(stat, file_type_hash, permission_hash)
    mode = stat.mode.to_s(8)

    object_type = mode.chars.first
    file_type = file_type_hash[object_type]

    file_permission = mode.chars.last(3)
    file_mode = file_permission.map { |file_per| permission_hash[file_per] }.join('')

    file_type + file_mode
  end

  def make_hardlinks(stat, files)
    max_hardlink_width = files.map { |file| File.stat(file).nlink.to_s.length }.max
    stat.nlink.to_s.rjust(max_hardlink_width)
  end

  def make_user(stat, files)
    max_user_width = files.map { |file| Etc.getpwuid(File.stat(file).uid).name.length }.max
    Etc.getpwuid(stat.uid).name.rjust(max_user_width)
  end

  def make_group(stat, files)
    max_group_width = files.map { |file| Etc.getgrgid(File.stat(file).gid).name.length }.max
    Etc.getgrgid(stat.gid).name.rjust(max_group_width)
  end

  file_lists = files.map do |file|
    stat = File.stat(file)
    total_blocks += stat.blocks

    file_size = stat.size.to_s.rjust(max_size_width)
    update_file_day = stat.mtime.strftime('%-b %e %H:%M')

    [make_file_mode_structure(stat, file_type_hash, permission_hash), make_hardlinks(stat, files), make_user(stat, files), make_group(stat, files), file_size, update_file_day,
     file].join(' ')
  end

  puts "total #{total_blocks}"
  puts file_lists
else
  file_names = build_file_names(files, COLS)
  max_width = make_max_width(file_names)
  display_file_names(file_names, max_width)
end

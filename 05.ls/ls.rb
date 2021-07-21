#!/usr/bin/env ruby

# frozen_string_literal: true

require 'optparse'
require 'etc'
require 'date'

def main
  options = ARGV.getopts('alr')

  files = reirieve_files(options['a'])
  files.reverse! if options['r']

  options['l'] ? output_fnames_with_details(files) : output_fnames(files)
end

def reirieve_files(option_a)
  flags = option_a ? File::FNM_DOTMATCH : 0
  base_directory = ARGV[0] || Dir.pwd
  file_names = Dir.glob('*', flags, base: base_directory)
  files = []
  file_names.each do |name|
    file_path = "#{base_directory}/#{name}"
    files << LS::File.new(file_path)
  end
  files
end

def output_fnames(files)
  col_width = 0
  files.each do |file|
    col_width = file.name.length if col_width < file.name.length
  end

  tab_width = 8 #=> lsのソースコードでcolorized outputされない時の初期値
  col_width = (col_width + tab_width) & ~(tab_width - 1)

  term_width = `tput cols`.to_i
  num_cols = term_width / col_width
  num_rows = files.size / num_cols
  num_rows += 1 unless (files.size % num_cols).zero?

  num_rows.times do |i|
    output_line = []
    limit = num_rows * (num_cols - 1) + i
    i.step(limit, num_rows) do |n|
      output_line << format("%-#{col_width}s", files[n]&.name || ' ')
    end

    puts output_line.join
  end
end

def output_fnames_with_details(files)
  blocks = 0
  cols_width = { nlink: 0, owner: 0, group: 0, size: 0 }
  files.each do |file|
    blocks += file.block
    cols_width[:nlink] = file.nlink.to_s.length if cols_width[:nlink] < file.nlink.to_s.length
    cols_width[:owner] = file.owner.length if cols_width[:owner] < file.owner.length
    cols_width[:group] = file.group.length if cols_width[:group] < file.group.length
    cols_width[:size] = file.size.to_s.length if cols_width[:size] < file.size.to_s.length
  end

  puts "total #{blocks}"

  files.each do |file|
    output_formatted_items(file, cols_width)
  end
end

def output_formatted_items(file, cols_width)
  formatted_items = []
  formatted_items << format("%#{cols_width[:nlink]}d", file.nlink)
  formatted_items << format("%-#{cols_width[:owner]}s", file.owner)
  formatted_items << format("%-#{cols_width[:group]}s", file.group)
  formatted_items << format("%#{cols_width[:size]}d", file.size)
  formatted_items <<
    if file.mtime.year == Date.today.year
      file.mtime.strftime('%_m %e %H:%M')
    else
      file.mtime.strftime('%_m %e %_5Y')
    end
  puts "#{file.mode}  #{formatted_items[0]} #{formatted_items[1]}  #{formatted_items[2]}  #{formatted_items[3]} #{formatted_items[4]} #{file.name}"
end

module LS
  class File
    attr_reader :name, :mode, :nlink, :owner, :group, :size, :mtime, :block

    def initialize(file_path)
      @name = ::File.basename(file_path)
      @size = ::File.size(file_path)
      @mtime = ::File.mtime(file_path)

      stat = ::File.stat(file_path)
      @mode = parse_mode_to_chars(stat.mode)
      @owner = Etc.getpwuid(stat.uid).name
      @group = Etc.getgrgid(stat.gid).name
      @nlink = stat.nlink
      @block = stat.blocks
    end

    private

    def parse_mode_to_chars(mode)
      octal_mode = format('%06d', mode.to_s(8))
      file_mode = convert_type_to_char(octal_mode[0..1])
      file_mode + convert_permission_to_char(octal_mode[3..5])
    end

    def convert_type_to_char(octal_type)
      {
        '01' => 'p',
        '02' => 'c',
        '04' => 'd',
        '06' => 'b',
        '10' => '-',
        '12' => 'l',
        '14' => 's'
      }[octal_type]
    end

    def convert_permission_to_char(octal_permission)
      file_permission = ''
      octal_permission.chars.each do |num|
        file_permission += {
          '0' => '---',
          '1' => '--x',
          '2' => '-w-',
          '3' => '-wx',
          '4' => 'r--',
          '5' => 'r-x',
          '6' => 'rw-',
          '7' => 'rwx'
        }[num]
      end
      file_permission
    end
  end
end

main

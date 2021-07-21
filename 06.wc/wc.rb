#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  options = ARGV.getopts('l', 'w', 'c')
  arg_files = ARGV.dup
  total_lines = total_words = total_bytes = 0

  ARGF.each(nil) do |file|
    cols = [file.count("\n"), file.split(/\s+/).length, file.bytesize]
    total_lines += cols[0]
    total_words += cols[1]
    total_bytes += cols[2]
    display_cols(cols, options)
    if arg_files.empty?
      print "\n"
      break
    end

    puts " #{ARGF.filename}"
  end

  return unless arg_files[1]

  print format_col(total_lines)
  print format_col(total_words)
  print format_col(total_bytes)
  puts ' total'
end

def display_cols(wc_cols, options)
  if options.values.any?
    cols = []
    cols << format_col(wc_cols[0]) if options['l']
    cols << format_col(wc_cols[1]) if options['w']
    cols << format_col(wc_cols[2]) if options['c']
    print cols.join
  else
    print format_col(wc_cols[0])
    print format_col(wc_cols[1])
    print format_col(wc_cols[2])
  end
end

def format_col(col)
  format('%8d', col)
end

main

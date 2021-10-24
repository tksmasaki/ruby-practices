# frozen_string_literal: true

require 'date'
require 'io/console/size'
require_relative './ls_file'

class Command
  def initialize(directory: nil, options: {})
    @options = options
    @directory = directory || Dir.pwd
    @files = retrieve_files
    @files.reverse! if @options['r']
  end

  def run_ls(term_width: IO.console_size[1])
    @options['l'] ? output_long_list : output_list(term_width)
  end

  private

  def retrieve_files
    flags = @options['a'] ? File::FNM_DOTMATCH : 0
    file_names = Dir.glob('*', flags, base: @directory)
    files = []
    file_names.each do |name|
      file_path = "#{@directory}/#{name}"
      files << LsFile.new(file_path)
    end
    files
  end

  def output_list(term_width)
    fname_width = @files.map { |f| f.name.length }.max
    tab_width = 8 #=> lsのソースコードでcolorized outputされない時の初期値(macOS)
    col_width = (fname_width + tab_width) & ~(tab_width - 1)

    num_cols = [(term_width / col_width), 1].max
    num_rows = @files.size / num_cols
    num_rows += 1 unless (@files.size % num_cols).zero?

    num_rows.times do |i|
      output_line = []
      limit = num_rows * (num_cols - 1) + i
      i.step(limit, num_rows) do |n|
        output_line << format("%-#{col_width}s", @files[n].name) if @files[n]
      end
      puts output_line.join.rstrip
    end
  end

  def output_long_list
    blocks = @files.map(&:blocks).sum
    puts "total #{blocks}"

    @files.each do |file|
      puts long_format_row(file)
    end
  end

  def long_format_row(file)
    cols_width = long_format_cols_width
    [
      "#{file.mode}#{' ' * 2}",
      "#{format("%#{cols_width[:nlink]}d", file.nlink)} ",
      "#{format("%-#{cols_width[:owner]}s", file.owner)}#{' ' * 2}",
      "#{format("%-#{cols_width[:group]}s", file.group)}#{' ' * 2}",
      "#{format("%#{cols_width[:size]}d", file.size)} ",
      format_mtime(file.mtime),
      file.name
    ].join
  end

  def long_format_cols_width
    {
      nlink: @files.map { |f| f.nlink.to_s.length }.max,
      owner: @files.map { |f| f.owner.to_s.length }.max,
      group: @files.map { |f| f.group.to_s.length }.max,
      size: @files.map { |f| f.size.to_s.length }.max
    }
  end

  def format_mtime(mtime)
    today = Date.today
    if mtime < today.prev_month(6).to_time || today.next_month(6).to_time < mtime
      "#{mtime.strftime('%b %e %_5Y')} "
    else
      "#{mtime.strftime('%b %e %H:%M')} "
    end
  end
end

# frozen_string_literal: true

require 'io/console/size'
require_relative './ls_file'
require_relative './ls_formatter'

class Command
  def initialize(directory: nil, options: {})
    @options = options
    @directory = directory || Dir.pwd
    @files = retrieve_files
    @files.reverse! if @options['r']
  end

  def ls_list(term_width: IO.console_size[1])
    if @options['l']
      blocks = @files.map(&:blocks).sum
      ["total #{blocks}", *long_file_list]
    else
      file_list(term_width)
    end
  end

  private

  def retrieve_files
    flags = @options['a'] ? File::FNM_DOTMATCH : 0
    file_names = Dir.glob('*', flags, base: @directory)
    file_names.map { |name| LsFile.new("#{@directory}/#{name}") }
  end

  def file_list(term_width)
    file_name_width = @files.map { |f| f.name.length }.max
    tab_width = 8 # => lsのソースコードでcolorized outputされない時の初期値(macOS)
    col_width = tab_width * (file_name_width / tab_width + 1) # => tab_widthの倍数になる

    num_cols = [(term_width / col_width), 1].max
    num_rows = (@files.size / num_cols.to_f).ceil

    Array.new(num_rows) do |i|
      limit = num_rows * (num_cols - 1) + i
      line = i.step(limit, num_rows).map do |n|
        @files[n] ? format("%-#{col_width}s", @files[n].name) : ''
      end
      line.join.rstrip
    end
  end

  def long_file_list
    cols_widths = {
      nlink: @files.map { |f| f.nlink.to_s.length }.max,
      owner: @files.map { |f| f.owner.length }.max,
      group: @files.map { |f| f.group.length }.max,
      size: @files.map { |f| f.size.to_s.length }.max
    }
    @files.map do |file|
      LsFormatter.format_long_row(file, cols_widths)
    end
  end
end

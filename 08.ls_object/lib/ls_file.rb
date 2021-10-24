# frozen_string_literal: true

require 'etc'
require_relative './mode_converter'

class LsFile
  attr_reader :name, :mode, :nlink, :owner, :group, :size, :mtime, :blocks

  def initialize(file_path)
    @name = File.basename(file_path)
    @size = File.size(file_path)
    @mtime = File.mtime(file_path)

    stat = File.stat(file_path)
    @mode = ModeConverter.convert_file_mode(stat.mode)
    @owner = Etc.getpwuid(stat.uid).name
    @group = Etc.getgrgid(stat.gid).name
    @nlink = stat.nlink
    @blocks = stat.blocks
  end
end

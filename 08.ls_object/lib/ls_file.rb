# frozen_string_literal: true

require 'etc'
require_relative './mode_converter'

class LsFile
  def initialize(file_path)
    @file_path = file_path
    @stat = File.stat(file_path)
  end

  def name
    File.basename(@file_path)
  end

  def size
    File.size(@file_path)
  end

  def mtime
    File.mtime(@file_path)
  end

  def mode
    ModeConverter.convert_file_mode(@stat.mode)
  end

  def owner
    Etc.getpwuid(@stat.uid).name
  end

  def group
    Etc.getgrgid(@stat.gid).name
  end

  def nlink
    @stat.nlink
  end

  def blocks
    @stat.blocks
  end
end

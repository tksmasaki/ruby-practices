# frozen_string_literal: true

require 'date'
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

  def mtime_before_or_after_month?(num_months, compared_time = Time.now)
    # 簡単に月数の加減をするために DateTimeクラスを使用（ Ruby3.0 では非推奨）
    base_time = DateTime.parse(compared_time.to_s)
    prev_time = base_time.prev_month(num_months).to_time
    next_time = base_time.next_month(num_months).to_time
    mtime < prev_time || next_time < mtime
  end
end

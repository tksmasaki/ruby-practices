# frozen_string_literal: true

require 'test/unit'
require 'date'
require 'etc'
require 'tempfile'
require_relative '../lib/ls_file'

class TestLsFile < Test::Unit::TestCase
  def test_get_attributes
    Tempfile.create('testfile') do |f|
      target = LsFile.new(f.path)
      assert_equal File.basename(f.path), target.name
      assert_equal f.size, target.size
      assert_equal f.mtime, target.mtime
      # テンポラリファイルのモード => 0o100600 (https://docs.ruby-lang.org/ja/3.0.0/class/Tempfile.html)
      assert_equal '-rw-------', target.mode
      assert_equal Etc.getpwuid(f.lstat.uid).name, target.owner
      assert_equal Etc.getgrgid(f.lstat.gid).name, target.group
      assert_equal f.lstat.nlink, target.nlink
      assert_equal f.lstat.blocks, target.blocks
    end
  end

  data(
    case1: [true, Date.today.prev_month(7), 6],
    case2: [false, Date.today.prev_month(5), 5],
    case3: [false, Date.today.prev_month(3), 4],
    case4: [true, Date.today.next_month(7), 6],
    case5: [false, Date.today.next_month(5), 5],
    case6: [false, Date.today.next_month(3), 4]
  )
  def test_mtime_before_or_after_month(data)
    expected, file_mdate, num_months = data
    Tempfile.create('testfile') do |f|
      ls_file = LsFile.new(f.path)

      # LsFile.mtime が指定の日時を返すようにする
      ls_file.define_singleton_method(:mtime) { file_mdate.to_time }

      assert_equal expected, ls_file.mtime_before_or_after_month?(num_months)
    end
  end
end

# frozen_string_literal: true

require 'test/unit'
require 'etc'
require 'tempfile'
require 'time'
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
    # 境界値
    case1: [true, 6, '2021-01-15 11:59:59'],
    case2: [false, 6, '2021-01-15 12:00:00'],
    case3: [false, 4, '2021-11-15 12:00:00'],
    case4: [true, 4, '2021-11-15 12:00:01'],
    # 代表値
    case5: [true, 5, '2020-11-15 12:00:00'],
    case6: [false, 5, '2021-04-15 12:00:00'],
    case7: [false, 5, '2021-10-15 12:00:00'],
    case8: [true, 5, '2022-03-15 12:00:00']
  )
  def test_mtime_before_or_after_month(data)
    expected, num_months, modified_time = data
    Tempfile.create('testfile') do |f|
      ls_file = LsFile.new(f.path)
      # LsFile.mtime が指定の日時を返すようにする
      ls_file.define_singleton_method(:mtime) { Time.parse(modified_time) }

      compared_time = Time.parse('2021-07-15 12:00:00')
      assert_equal expected, ls_file.mtime_before_or_after_month?(num_months, compared_time)
    end
  end
end

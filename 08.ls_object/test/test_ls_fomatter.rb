# frozen_string_literal: true

require 'test/unit'
require 'date'
require_relative '../lib/ls_formatter'

class TestLsFile < Test::Unit::TestCase
  data(
    # テンポラリファイルのモード => -rw-------
    case1: [
      "-rw-------  1 root  staff  100 #{Date.today.strftime('%b %e %H:%M')} test_file",
      [1, 4, 5, 3]
    ],
    case2: [
      "-rw-------    1 root    staff      100 #{Date.today.strftime('%b %e %H:%M')} test_file",
      [3, 6, 7, 5]
    ],
    case3: [
      "-rw-------  1 root  staff  100 #{Date.today.strftime('%b %e %H:%M')} test_file",
      [0, 0, 0, 0]
    ]
  )
  def test_format_long_row(data)
    Tempfile.create('testfile') do |f|
      ls_file = LsFile.new(f.path)
      expected, cols_width = data

      # 特定の値を返すようにする
      ls_file.define_singleton_method(:nlink) { 1 }
      ls_file.define_singleton_method(:owner) { 'root' }
      ls_file.define_singleton_method(:group) { 'staff' }
      ls_file.define_singleton_method(:size) { '100' }
      ls_file.define_singleton_method(:mtime) { Date.today.to_time }
      ls_file.define_singleton_method(:name) { 'test_file' }

      assert_equal expected, LsFormatter.format_long_row(ls_file, *cols_width)
    end
  end

  data(
    case1: [Date.today.prev_month(7), '%b %e %_5Y'],
    case2: [Date.today.prev_month(6), '%b %e %H:%M'],
    case3: [Date.today.prev_month(5), '%b %e %H:%M'],
    case4: [Date.today.next_month(7), '%b %e %_5Y'],
    case5: [Date.today.next_month(6), '%b %e %H:%M'],
    case6: [Date.today.next_month(5), '%b %e %H:%M']
  )
  def test_format_mtime(data)
    Tempfile.create('testfile') do |f|
      modified_date, pattern = data
      ls_file = LsFile.new(f.path)

      # LsFile.mtime が指定の日時を返すようにする
      ls_file.define_singleton_method(:mtime) { modified_date.to_time }

      assert_equal modified_date.strftime(pattern), LsFormatter.format_mtime(ls_file)
    end
  end
end

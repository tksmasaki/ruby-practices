# frozen_string_literal: true

require 'test/unit'
require 'tempfile'
require 'time'
require_relative '../lib/ls_formatter'

class TestLsFile < Test::Unit::TestCase
  data(
    # テンポラリファイルのモード => -rw-------
    case1: [
      '-rw-------  1 root  staff  100 Jul 15 12:00 test_file',
      { nlink: 1, owner: 4, group: 5, file_size: 3 }
    ],
    case2: [
      '-rw-------    1 root    staff      100 Jul 15 12:00 test_file',
      { nlink: 3, owner: 6, group: 7, file_size: 5 }
    ],
    case3: [
      '-rw-------  1 root  staff  100 Jul 15 12:00 test_file',
      { nlink: 0, owner: 0, group: 0, file_size: 0 }
    ]
  )
  def test_format_long_row(data)
    Tempfile.create('testfile') do |f|
      expected, col_widths = data
      fixed_time = Time.parse('2021-07-15 12:00:00')

      ls_file = LsFile.new(f.path)
      # 特定の値を返すようにする
      ls_file.define_singleton_method(:nlink) { 1 }
      ls_file.define_singleton_method(:owner) { 'root' }
      ls_file.define_singleton_method(:group) { 'staff' }
      ls_file.define_singleton_method(:size) { 100 }
      ls_file.define_singleton_method(:mtime) { fixed_time }
      ls_file.define_singleton_method(:name) { 'test_file' }

      assert_equal expected, LsFormatter.format_long_row(ls_file, col_widths, fixed_time)
    end
  end

  data(
    # 境界値
    # 6ヶ月前後の表示が同じになるが、実際のファイル更新日時と秒数まで一致することは想定していない
    case1: ['Jan 15  2021', '2021-01-15 11:59:59'],
    case2: ['Jan 15 12:00', '2021-01-15 12:00:00'],
    case3: ['Jan 15 12:00', '2022-01-15 12:00:00'],
    case4: ['Jan 15  2022', '2022-01-15 12:00:01'],
    # 代表値
    case5: ['Oct 15  2020', '2020-10-15 12:00:00'],
    case6: ['Apr 15 12:00', '2021-04-15 12:00:00'],
    case7: ['Nov 15 12:00', '2021-11-15 12:00:00'],
    case8: ['Mar 15  2022', '2022-03-15 12:00:00']
  )
  def test_format_mtime(data)
    Tempfile.create('testfile') do |f|
      expected, modified_time = data
      ls_file = LsFile.new(f.path)

      # LsFile.mtime が指定の日時を返すようにする
      ls_file.define_singleton_method(:mtime) { Time.parse(modified_time) }

      assert_equal expected, LsFormatter.format_mtime(ls_file, Time.parse('2021-07-15 12:00:00'))
    end
  end
end

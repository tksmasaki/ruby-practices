# frozen_string_literal: true

require 'test/unit'
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
end

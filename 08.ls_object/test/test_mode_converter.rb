# frozen_string_literal: true

require 'test/unit'
require_relative '../lib/mode_converter'

class TestModeConverter < Test::Unit::TestCase
  data(
    case1: ['p-----x-w-', 0o10012],
    case2: ['c-wxr--r-x', 0o20345],
    case3: ['drw-rwx---', 0o40670],
    case4: ['b---------', 0o60000],
    case5: ['-rwxr-xr-x', 0o100755],
    case6: ['lrw-rw-rw-', 0o120666],
    case7: ['srw-r--r--', 0o140644]
  )
  def test_convert_file_mode(data)
    # target => File::Stat.modeの値
    expected, target = data
    assert_equal expected, ModeConverter.convert_file_mode(target)
  end
end

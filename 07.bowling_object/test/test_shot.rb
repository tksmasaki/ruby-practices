# frozen_string_literal: true

require 'test/unit'
require_relative '../lib/shot'

class TestShot < Test::Unit::TestCase
  data(case1: [1, '1'],
       case2: [10, '10'],
       case3: [10, 'X'])
  def test_score(data)
    expected, mark = data
    shot = Shot.new(mark)
    assert_equal expected, shot.score
  end
end

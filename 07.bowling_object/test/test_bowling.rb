# frozen_string_literal: true

require 'test/unit'
require_relative '../lib/bowling'

class TestBowling < Test::Unit::TestCase
  data(case1: [139, '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5'],
       case2: [164, '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X'],
       case3: [107, '0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4'],
       case4: [134, '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0'],
       case5: [300, 'X,X,X,X,X,X,X,X,X,X,X,X'])
  def test_calc_score(data)
    expected, target = data
    assert_equal expected, calc_score(target)
  end
end

# frozen_string_literal: true

require 'test/unit'
require_relative '../lib/frame'

class TestFrame < Test::Unit::TestCase
  data(case1: [6, '1', '5'],
       case2: [10, '2', '8'],
       case3: [10, 'X', '0'])
  def test_score_for_two_shots(data)
    expected, first_shot, second_shot = data
    frame = Frame.new(first_shot, second_shot)
    assert_equal expected, frame.score
  end

  data(case1: [15, '1', '5', '9'],
       case2: [20, '2', '8', 'X'],
       case3: [20, 'X', '3', '7'],
       case4: [30, 'X', 'X', 'X'])
  def test_score_for_three_shots(data)
    expected, first_shot, second_shot, third_shot = data
    frame = Frame.new(first_shot, second_shot, third_shot)
    assert_equal expected, frame.score
  end

  data(case1: [%w[1 5], '1', '5'],
       case2: [%w[2 8], '2', '8'],
       case3: [%w[X 0], 'X', '0'])
  def test_marks_for_two_shots(data)
    expected, first_shot, second_shot = data
    frame = Frame.new(first_shot, second_shot)
    assert_equal expected, frame.marks
  end

  data(case1: [%w[1 5 9], '1', '5', '9'],
       case2: [%w[2 8 X], '2', '8', 'X'],
       case3: [%w[X 3 7], 'X', '3', '7'],
       case4: [%w[X X X], 'X', 'X', 'X'])
  def test_marks_for_three_shots(data)
    expected, first_shot, second_shot, third_shot = data
    frame = Frame.new(first_shot, second_shot, third_shot)
    assert_equal expected, frame.marks
  end

  data(case1: [[1, 5], '1', '5'],
       case2: [[2, 8], '2', '8'],
       case3: [[10, 0], 'X', '0'])
  def test_shot_scores_for_two_shots(data)
    expected, first_shot, second_shot = data
    frame = Frame.new(first_shot, second_shot)
    assert_equal expected, frame.shot_scores
  end

  data(case1: [[1, 5, 9], '1', '5', '9'],
       case2: [[2, 8, 10], '2', '8', 'X'],
       case3: [[10, 3, 7], 'X', '3', '7'],
       case4: [[10, 10, 10], 'X', 'X', 'X'])
  def test_shot_scores_for_three_shots(data)
    expected, first_shot, second_shot, third_shot = data
    frame = Frame.new(first_shot, second_shot, third_shot)
    assert_equal expected, frame.shot_scores
  end
end

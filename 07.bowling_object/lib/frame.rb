# frozen_string_literal: true

require_relative './shot'

class Frame
  def initialize(first_shot, second_shot, third_shot = nil)
    @first_shot = Shot.new(first_shot)
    @second_shot = Shot.new(second_shot)
    @third_shot = Shot.new(third_shot) unless third_shot.nil?
  end

  def score
    score = [@first_shot.score, @second_shot.score].sum
    score += @third_shot.score unless @third_shot.nil?
    score
  end

  def marks
    marks = [@first_shot.mark, @second_shot.mark]
    marks << @third_shot.mark unless @third_shot.nil?
    marks
  end

  def shot_scores
    shot_scores = [@first_shot.score, @second_shot.score]
    shot_scores << @third_shot.score unless @third_shot.nil?
    shot_scores
  end
end

# frozen_string_literal: true

require_relative './shot'

class Frame
  def initialize(first_shot, second_shot, third_shot = nil)
    @first_shot = Shot.new(first_shot)
    @second_shot = Shot.new(second_shot)
    @third_shot = Shot.new(third_shot) unless third_shot.nil?
  end

  def score
    @third_shot.nil? ? [@first_shot.score, @second_shot.score].sum : [@first_shot.score, @second_shot.score, @third_shot.score].sum
  end

  def marks
    @third_shot.nil? ? [@first_shot.mark, @second_shot.mark] : [@first_shot.mark, @second_shot.mark, @third_shot.mark]
  end

  def shot_scores
    @third_shot.nil? ? [@first_shot.score, @second_shot.score] : [@first_shot.score, @second_shot.score, @third_shot.score]
  end
end

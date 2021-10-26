# frozen_string_literal: true

require_relative './frame'

class Game
  def initialize(csv_record)
    @frames = convert_csv_record_to_frames(csv_record)
  end

  def score
    scores = @frames.map.with_index do |frame, i|
      score = frame.score
      score == 10 && i < 9 ? score + add_score(i) : score
    end

    scores.sum
  end

  private

  def convert_csv_record_to_frames(csv_record)
    marks = []
    csv_record.split(',').each do |mark|
      if mark == 'X'
        marks << mark << '0'
      else
        marks << mark
      end
    end

    generate_frames(marks)
  end

  def generate_frames(marks)
    frames = Array.new(9)
    marks = marks.each_slice(2).to_a
    marks.each_with_index do |frame_marks, i|
      break if i >= 9

      frames[i] = Frame.new(*frame_marks)
    end

    tenth_marks = marks[9..].map { |v| v[0] == 'X' ? 'X' : v }
    frames << Frame.new(*tenth_marks.flatten)
  end

  def add_score(index)
    frames = @frames[index..(index + 2)]

    if frames[0].marks[0] == 'X' && index == 8
      @frames[9].shot_scores[0..1].sum
    elsif frames[0].marks[0] == 'X'
      frames[1].marks[0] == 'X' ? frames[1].shot_scores[0] + frames[2].shot_scores[0] : frames[1].score
    else
      frames[1].shot_scores[0]
    end
  end
end

# frozen_string_literal: true

require_relative './frame'

class Game
  def initialize(csv_record)
    @frames = convert_csv_record_to_frames(csv_record)
  end

  def score
    result = 0
    @frames.each_with_index do |frame, i|
      result += frame.score
      next unless frame.score == 10 && i < 9

      result += add_score(i)
    end

    result
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
      if i < 9
        frames[i] = Frame.new(*frame_marks)
      else
        tenth_marks = []
        marks[9..-1].each do |marks_array|
          if marks_array[0] == 'X'
            tenth_marks << 'X'
          else
            tenth_marks += marks_array
          end
        end
        frames[9] = Frame.new(*tenth_marks)
        break
      end
    end

    frames
  end

  def add_score(index)
    if @frames[index].marks[0] == 'X' && index == 8
      @frames[9].shot_scores[0..1].sum
    elsif @frames[index].marks[0] == 'X'
      @frames[index + 1].marks[0] == 'X' ? @frames[index + 1].shot_scores[0] + @frames[index + 2].shot_scores[0] : @frames[index + 1].score
    else
      @frames[index + 1].shot_scores[0]
    end
  end
end

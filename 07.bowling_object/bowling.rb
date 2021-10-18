#!/usr/bin/env ruby

# frozen_string_literal: true

def main
  puts calc_score(ARGV[0])
end

def calc_score(frames_str)
  frames = frames_str_to_array(frames_str)
  result = 0
  frames.each_with_index do |frame, i|
    result += frame.sum
    next unless frame.sum == 10 && i < 9

    result +=
      if frame[0] == 10
        frames[i + 1][0] == 10 ? frames[i + 1][0] + frames[i + 2][0] : frames[i + 1].sum
      else
        frames[i + 1][0]
      end
  end

  result
end

def frames_str_to_array(str)
  scores = []
  str.split(',').each do |score|
    if score == 'X'
      scores << 10 << 0
    else
      scores << score.to_i
    end
  end

  scores.each_slice(2).to_a
end

main if __FILE__ == $PROGRAM_NAME

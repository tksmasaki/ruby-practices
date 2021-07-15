#!/usr/bin/env ruby

# frozen_string_literal: true

scores = []
ARGV[0].split(',').each do |score|
  if score == 'X'
    scores << 10 << 0
  else
    scores << score.to_i
  end
end

frames = []
scores.each_slice(2) do |score|
  frames << score
end

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

puts result

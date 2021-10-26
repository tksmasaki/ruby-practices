#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative './game'

def main
  puts calc_score(ARGV[0])
end

def calc_score(csv_record)
  Game.new(csv_record).score
end

main if __FILE__ == $PROGRAM_NAME

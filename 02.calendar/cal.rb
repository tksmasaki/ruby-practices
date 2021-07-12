#!/usr/bin/env ruby

# frozen_string_literal: true

require 'optparse'
require 'date'

WEEKDAYS = %w[日 月 火 水 木 金 土].freeze
WEEK_STR_LENGTH = 20
REGEX_OF_MONTH = /\A[1-9]\z|\A1[0-2]\z|\A0[1-9]\z/.freeze
REGEX_OF_YEAR = /\A[0-9]{1,3}[0-9]\z|\A[0-9]{,3}[1-9]\z/.freeze

options = ARGV.getopts('y:m:', 'h')
today = Date.today

# 表示する年月を設定
year =
  if options['y']
    unless options['y'].match?(REGEX_OF_YEAR)
      warn "cal: year '#{options['y']}' not in range 1..9999"
      return
    end
    options['y'].to_i
  else
    today.year
  end
month =
  if options['m']
    unless options['m'].match?(REGEX_OF_MONTH)
      warn "cal: #{options['m']} is neither a month number (1..12) nor a name"
      return
    end
    options['m'].to_i
  else
    today.month
  end

# 出力する月の最終日のDateオブジェクト生成
end_of_month = Date.new(year, month, -1)
# m月 Yを出力
puts end_of_month.strftime('%-m月 %-Y').center(WEEK_STR_LENGTH)
# 曜日の文字列を出力
puts WEEKDAYS.join(' ')

one_week = []
(1..end_of_month.day).each do |day|
  date = Date.new(year, month, day)
  one_week <<
    (
      # 今日の日付の場合は、文字色と背景色を反転
      if !options['h'] && date == today
        format("\e[7m%2d\e[0m", day)
      else
        format('%2d', day)
      end
    )

  # date == 土曜日 or 最終日の場合、one_week配列を出力する
  next unless date.saturday? || day == end_of_month.day

  # 初週の場合に配列の要素数を7個に調整する
  (7 - one_week.size).times { one_week.unshift('  ') } if (day != end_of_month.day) && (one_week.size < 7)
  puts one_week.join(' ')
  one_week.clear
end

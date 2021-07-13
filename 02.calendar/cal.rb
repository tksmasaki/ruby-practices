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

case Date.new(year, month, 1).wday
when 1
  print ' ' * 3
when 2
  print ' ' * 6
when 3
  print ' ' * 9
when 4
  print ' ' * 12
when 5
  print ' ' * 15
when 6
  print ' ' * 18
end

(1..end_of_month.day).each do |day|
  date = Date.new(year, month, day)
  # 今日の日付の場合は、文字色と背景色を反転
  print(!options['h'] && date == today ? format("\e[7m%2d\e[0m ", day) : format('%2d ', day))
  print "\n" if date.saturday? || date.day == end_of_month.day
end
print "\n"

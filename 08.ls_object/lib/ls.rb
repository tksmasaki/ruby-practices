#!/usr/bin/env ruby

# frozen_string_literal: true

require 'optparse'
require_relative './command'

options = ARGV.getopts('alr')
directory = ARGV[0]
command = Command.new(directory: directory, options: options)
puts command.ls_list

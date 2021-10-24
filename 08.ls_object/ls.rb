#!/usr/bin/env ruby

# frozen_string_literal: true

require 'optparse'
require_relative './lib/command'

options = ARGV.getopts('alr')
directory = ARGV[0]

Command.new(directory: directory, options: options).run_ls

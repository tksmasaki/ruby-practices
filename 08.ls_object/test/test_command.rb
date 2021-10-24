# frozen_string_literal: true

require 'test/unit'
require 'stringio'
require_relative '../lib/command'

class TestCommand < Test::Unit::TestCase
  setup do
    pwd = File.expand_path('./fixture', __dir__)
    Dir.chdir(pwd)
    $stdout = StringIO.new
  end

  def test_run_ls_on_term_width100
    command = Command.new
    command.run_ls(term_width: 100)

    expected = <<~TEXT
      Gemfile                 bin                     node_modules            tmp
      Gemfile.lock            config                  package.json            vendor
      README.md               config.ru               postcss.config.js       yarn.lock
      Rakefile                db                      public
      app                     lib                     storage
      babel.config.js         log                     test
    TEXT
    assert_equal expected, $stdout.string
  end

  def test_run_ls_on_term_width75
    command = Command.new
    command.run_ls(term_width: 75)

    expected = <<~TEXT
      Gemfile                 config                  postcss.config.js
      Gemfile.lock            config.ru               public
      README.md               db                      storage
      Rakefile                lib                     test
      app                     log                     tmp
      babel.config.js         node_modules            vendor
      bin                     package.json            yarn.lock
    TEXT
    assert_equal expected, $stdout.string
  end

  def test_run_ls_with_option_a_on_term_width100
    command = Command.new(options: { 'a' => true })
    command.run_ls(term_width: 100)

    expected = <<~TEXT
      .                       Gemfile.lock            config.ru               public
      ..                      README.md               db                      storage
      .browserslistrc         Rakefile                lib                     test
      .gitattributes          app                     log                     tmp
      .gitignore              babel.config.js         node_modules            vendor
      .ruby-version           bin                     package.json            yarn.lock
      Gemfile                 config                  postcss.config.js
    TEXT
    assert_equal expected, $stdout.string
  end

  def test_run_ls_with_option_l
    command = Command.new(options: { 'l' => true })
    command.run_ls

    expected = `\ls -l`
    assert_equal expected, $stdout.string
  end

  def test_run_ls_with_option_r_on_term_width100
    command = Command.new(options: { 'r' => true })
    command.run_ls(term_width: 100)

    expected = <<~TEXT
      yarn.lock               postcss.config.js       config.ru               README.md
      vendor                  package.json            config                  Gemfile.lock
      tmp                     node_modules            bin                     Gemfile
      test                    log                     babel.config.js
      storage                 lib                     app
      public                  db                      Rakefile
    TEXT
    assert_equal expected, $stdout.string
  end

  def test_run_ls_with_option_alr
    command = Command.new(options: { 'a' => true, 'l' => true, 'r' => true })
    command.run_ls(term_width: 100)

    expected = `\ls -alr`
    assert_equal expected, $stdout.string
  end

  def test_run_ls_with_dir_arg_on_term_width100
    command = Command.new(directory: 'app')
    command.run_ls(term_width: 100)

    expected = <<~TEXT
      assets          controllers     javascript      mailers         views
      channels        helpers         jobs            models
    TEXT
    assert_equal expected, $stdout.string
  end

  teardown do
    $stdout = STDOUT
  end
end

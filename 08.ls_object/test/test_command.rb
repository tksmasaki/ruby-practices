# frozen_string_literal: true

require 'test/unit'
require_relative '../lib/command'

class TestCommand < Test::Unit::TestCase
  setup do
    pwd = File.expand_path('./fixture', __dir__)
    Dir.chdir(pwd)
  end

  def test_ls_list_on_term_width100
    expected = [
      'Gemfile                 bin                     node_modules            tmp',
      'Gemfile.lock            config                  package.json            vendor',
      'README.md               config.ru               postcss.config.js       yarn.lock',
      'Rakefile                db                      public',
      'app                     lib                     storage',
      'babel.config.js         log                     test'
    ]
    command = Command.new
    assert_equal expected, command.ls_list(term_width: 100)
  end

  def test_ls_list_on_term_width75
    expected = [
      'Gemfile                 config                  postcss.config.js',
      'Gemfile.lock            config.ru               public',
      'README.md               db                      storage',
      'Rakefile                lib                     test',
      'app                     log                     tmp',
      'babel.config.js         node_modules            vendor',
      'bin                     package.json            yarn.lock'
    ]
    command = Command.new
    assert_equal expected, command.ls_list(term_width: 75)
  end

  def test_ls_list_with_option_a_on_term_width100
    expected = [
      '.                       Gemfile.lock            config.ru               public',
      '..                      README.md               db                      storage',
      '.browserslistrc         Rakefile                lib                     test',
      '.gitattributes          app                     log                     tmp',
      '.gitignore              babel.config.js         node_modules            vendor',
      '.ruby-version           bin                     package.json            yarn.lock',
      'Gemfile                 config                  postcss.config.js'
    ]
    command = Command.new(options: { 'a' => true })
    assert_equal expected, command.ls_list(term_width: 100)
  end

  def test_ls_list_with_option_r_on_term_width100
    expected = [
      'yarn.lock               postcss.config.js       config.ru               README.md',
      'vendor                  package.json            config                  Gemfile.lock',
      'tmp                     node_modules            bin                     Gemfile',
      'test                    log                     babel.config.js',
      'storage                 lib                     app',
      'public                  db                      Rakefile'
    ]
    command = Command.new(options: { 'r' => true })
    assert_equal expected, command.ls_list(term_width: 100)
  end

  def test_ls_list_with_dir_arg_on_term_width100
    expected = [
      'assets          controllers     javascript      mailers         views',
      'channels        helpers         jobs            models'
    ]
    command = Command.new(directory: 'app')
    assert_equal expected, command.ls_list(term_width: 100)
  end

  # 期待値(expected) => ファイルの所有者などの実行環境に依存する項目があるため、lsコマンドの実行結果を代入
  def test_ls_list_with_option_l
    expected = `ls -l`.split("\n")
    command = Command.new(options: { 'l' => true })
    assert_equal expected, command.ls_list
  end

  def test_ls_list_with_option_alr
    expected = `ls -alr`.split("\n")
    command = Command.new(options: { 'a' => true, 'l' => true, 'r' => true })
    assert_equal expected, command.ls_list
  end
end

require "test_helper"

class ClirTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Clir::VERSION
  end

  def test_clir_parse_exists
    assert defined?(CLI)
    assert CLI.respond_to?(:parse)
  end

  def test_cli_parse_main_command
    CLI.parse("main_command -optionone --optiontwo -optionval=val firstcomp param=valeur -l".split(' '))
    assert CLI.main_command == 'main_command'
    assert CLI.options.key?(:optionone)
    assert CLI.options[:optionone] === true
    assert CLI.options.key?(:optiontwo)
    assert CLI.options[:optiontwo] === true
    assert CLI.options.key?(:optionval)
    assert CLI.options[:optionval] == 'val'
    assert CLI.options.key?(:l)
    assert CLI.options[:l] === true
    assert CLI.params.key?(:param)
    assert CLI.params[:param] == 'valeur'
    assert CLI.components[0] == 'firstcomp'
  end

  def test_app_can_define_short_options
    CLI.set_options_table({o: :open})
    CLI.parse("main -o".split(' '))
    assert CLI.options.key?(:open)
    assert CLI.options[:open] === true
  end

  def test_app_can_overwrite_short_options
    CLI.parse('cmd -v'.split(' '))
    assert CLI.options.key?(:verbose)
    assert CLI.options[:verbose] === true

    CLI.set_options_table(:v => :verbatim)
    CLI.parse('cmd -v'.split(' '))
    assert CLI.options.key?(:verbatim)
    refute CLI.options.key?(:verbose)
    assert CLI.options[:verbatim] === true
    refute CLI.options[:verbose]
  end

end

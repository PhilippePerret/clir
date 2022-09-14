require "test_helper"

class StateMethodsTests < Minitest::Test

  def test_verbosity_method
    CLI.set_options_table(nil)
    CLI.parse('macommande -v')
    assert verbose?
    CLI.parse('macommande')
    refute verbose?
    CLI.parse('macommande -v')
    assert verbose?
    CLI.parse('macommande -q')
    refute verbose?
  end

  def test_debug_state
    CLI.parse('macom')
    refute debug?
    CLI.parse('macom -x')
    assert debug?
    CLI.parse('macomm')
    refute debug?
    CLI.parse('macom --debug')
    assert debug?
    CLI.parse('macomm')
    refute debug?
  end

  def test_tests_state
    CLI.parse('macomm')
    refute test?
    ENV['CLI_TEST'] = 'true'
    CLI.parse('macomm')
    assert test?
    ENV['CLI_TEST'] = nil
    CLI.parse('macomm')
    refute test?    
  end

  def test_help_state
    CLI.parse('macom')
    refute help?
    CLI.parse('macom -h')
    assert help?
    CLI.parse('macom')
    refute help?
    CLI.parse('macom --help')
    assert help?
    CLI.parse('macom')
    refute help?
    CLI.parse('help')
    assert help?
    CLI.parse('macom')
    refute help?
    CLI.parse('aide')
    assert help?
    CLI.parse('macom')
    refute help?
  end


end

require "test_helper"

class StateMethodsTests < Minitest::Test


  def test_verbosity_method
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


end

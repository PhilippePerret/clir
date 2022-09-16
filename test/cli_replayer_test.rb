require "test_helper"

class CliReplayerTests < Minitest::Test


  def test_class_exists
    assert defined?(CLI::Replayer)
  end

  def test_replayer_respond_to_inputs_and_return_values
    assert_respond_to CLI::Replayer, :inputs
    CLI.init
    inp = CLI::Replayer.inputs
    assert_nil inp
  end

  def test_replayer_replayable_method
    assert_respond_to CLI::Replayer, :replayable?
    refute CLI::Replayer.replayable?
  end

  def test_cant_start_replayer_if_not_replayable
    CLI::Replayer.start
    refute CLI::Replayer.on?    
  end

  def test_can_start_replayer_if_replayable
    CLI::Replayer.start
    assert CLI::Replayer.on?
  end

  def test_replayer_respond_to_on_and_return_right_value
    assert_respond_to CLI::Replayer, :on?
    CLI.init
    refute CLI::Replayer.on?
  end


end

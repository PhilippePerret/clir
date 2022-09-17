require "test_helper"

class CliReplayerTests < Minitest::Test


  def test_replayer_class_exists
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
    replay_file = CLI::Replayer.last_command_file(CLI.command_name)
    delete_if_exist(replay_file)
    refute CLI::Replayer.replayable?
    File.write(replay_file, '#####')
    assert CLI::Replayer.replayable?
    delete_if_exist(replay_file) # to avoid errors
  end

  def test_cant_start_replayer_if_not_replayable
    delete_if_exist(CLI::Replayer.last_command_file)
    CLI::Replayer.start
    refute CLI::Replayer.on?    
  end

  def test_can_start_replayer_if_replayable
    replay_file = CLI::Replayer.last_command_file
    File.write(replay_file, '#####')
    CLI::Replayer.start
    assert CLI::Replayer.on?
    delete_if_exist(replay_file) # to avoid errors
  end

  def test_replayer_respond_to_on_and_return_right_value
    delete_if_exist(CLI::Replayer.last_command_file)
    assert_respond_to CLI::Replayer, :on?
    CLI.init
    refute CLI::Replayer.on?
  end


end

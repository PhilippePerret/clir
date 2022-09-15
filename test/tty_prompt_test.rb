require "test_helper"

class TTYPromptTests < Minitest::Test

  def test_classes_should_exist
    assert defined?(TestTTYMethods)
  end

  def test_Q_class_should_exist_and_respond_to_methods
    assert defined?(Q)
    assert Q.respond_to?(:toggle_mode)
    assert Q.respond_to?(:ask)
    assert Q.respond_to?(:select)
    assert Q.respond_to?(:multiline)
  end

  # On ne peut pas vérifier, malheureusement
  # def test_Q_should_be_the_right_class_outside_tests
  #   ARGV.clear;ARGV << 'macommande'
  #   CLI.init
  #   assert_equal "CLI::RegularTTYPrompt", Q.name
  # end
  # def test_Q_should_be_right_class_with_tests
  #   ARGV.clear;ARGV << 'macommande --test'
  #   CLI.init
  #   assert_equal "CLI::TestTTYPrompt", Q.name
  # end

  def test_Q_receive_inputs_in_test_mode
    ENV['CLI_TEST'] = 'true'
    ENV['CLI_TEST_INPUTS'] = nil
    CLI.init
    assert_equal [], Q.inputs

    ENV['CLI_TEST_INPUTS'] = ["A","B","C"].to_json
    CLI.init
    assert_equal ['A','B','C'], Q.inputs
  end

  def test_Q_ask_method_in_test_mode
    ENV['CLI_TEST'] = 'true'
    ENV['CLI_TEST_INPUTS'] = ["Marion Mic"].to_json
    CLI.init
    res = nil
    out, err = capture_io { res = Q.ask("What's your name?") }
    assert_match out, "What's your name\?"
    assert_match out, "Marion"
    assert res == 'Marion Mic'
    assert_empty err
  end

end

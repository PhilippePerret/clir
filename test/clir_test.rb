require "test_helper"

class ClirTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Clir::VERSION
  end

  def test_clir_parse_exists
    assert defined?(CLI)
    assert CLI.respond_to?(:parse)
  end

  def test_clir_parse_command_name
    assert defined?(CLI)
    assert_respond_to CLI, :command_name
    assert_equal 'rake_test_loader', CLI.command_name
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

  def test_marker_tests_file_constant_exists
    assert defined?(CLI::MARKER_TESTS_FILE), "la constante CLI::MARKER_TESTS_FILE devrait être définie"
  end

  def test_test_on_by_marker
    marker_existait = File.exist?(CLI::MARKER_TESTS_FILE)
    if marker_existait
      FileUtils.cp(CLI::MARKER_TESTS_FILE, "#{CLI::MARKER_TESTS_FILE}-backup")
    else
      File.write(CLI::MARKER_TESTS_FILE, "avec rien")
    end
    assert_respond_to CLI, :set_tests_on_with_marker
    assert_respond_to CLI, :unset_tests_on_with_marker
    CLI.unset_tests_on_with_marker
    refute File.exist?(CLI::MARKER_TESTS_FILE), "Le fichier #{CLI::MARKER_TESTS_FILE} (CLI::MARKER_TESTS_FILE) ne devrait pas exister…"
    refute test?, "Mode test should be OFF"
    Clir::State.reset
    CLI.set_tests_on_with_marker
    assert File.exist?(CLI::MARKER_TESTS_FILE), "Le fichier #{CLI::MARKER_TESTS_FILE} (CLI::MARKER_TESTS_FILE) devrait exister…"
    assert test?, "Mode test should be ON"
    Clir::State.reset
    CLI.unset_tests_on_with_marker
    refute File.exist?(CLI::MARKER_TESTS_FILE), "Le fichier #{CLI::MARKER_TESTS_FILE} (CLI::MARKER_TESTS_FILE) ne devrait plus exister…"
    refute test?, "Mode test should be OFF"

    # 
    # On remet le marqueur s'il existait
    # 
    if marker_existait
      FileUtils.cp("#{CLI::MARKER_TESTS_FILE}-backup", CLI::MARKER_TESTS_FILE)
    end
  end

end

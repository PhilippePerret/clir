require "test_helper"

class ConsoleMethodsTests < Minitest::Test

  def test_get_console_dimensions
    columns_count = `tput cols`.strip.to_i
    lines_count   = `tput lines`.strip.to_i 
    assert_equal columns_count, console_width
    assert_equal lines_count,   console_height
  end

  def test_it_can_clear_console
    out, err = capture_io { clear }
    assert_equal "\n\033c\n", out
    assert_empty err
  end

  def test_it_can_write_at_in_the_console
    out, err = capture_io { write_at("bonjour", 4, 4) }
    assert_equal out, "\e[4;4Hbonjour\n"
    assert_empty err
  end

  def test_it_can_use_less_command
    out, err = capture_io { less("Un texte très court.") }
    assert_match "Un texte très court.", out
    assert_empty err
  end

end

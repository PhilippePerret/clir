require "test_helper"

class ClirColorTest < Minitest::Test


  # --- TEST DES COULEURS ---

  def test_it_can_use_blue_color
    assert_equal "\033[0;96mMon essai\033[0m", 'Mon essai'.bleu
    assert_equal "\033[0;96mMon essai\033[0m", 'Mon essai'.blue
  end

  def test_it_can_use_green_color
    assert_equal "\033[0;92mMon essai\033[0m", 'Mon essai'.vert
    assert_equal "\033[0;92mMon essai\033[0m", 'Mon essai'.green
  end

  def test_it_can_use_red_color
    assert_equal "\033[0;91mMon essai\033[0m", 'Mon essai'.red
    assert_equal "\033[0;91mMon essai\033[0m", 'Mon essai'.rouge
  end

  def test_it_can_use_purple_color
    assert_equal "\033[1;94mMon essai\033[0m", 'Mon essai'.purple
    assert_equal "\033[1;94mMon essai\033[0m", 'Mon essai'.mauve
  end

  def test_it_can_use_yellow_color
    assert_equal "\033[0;93mMon essai\033[0m", 'Mon essai'.yellow
    assert_equal "\033[0;93mMon essai\033[0m", 'Mon essai'.jaune
  end

  def test_it_can_use_grey_color
    assert_equal "\033[0;90mMon essai\033[0m", 'Mon essai'.grey
    assert_equal "\033[0;90mMon essai\033[0m", 'Mon essai'.gris
  end

  def test_it_can_use_orange_color
    assert_equal "\033[38;5;214mMon essai\033[0m", 'Mon essai'.orange
  end
  
end

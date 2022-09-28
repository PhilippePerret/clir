require "test_helper"

class ClirStringExtensionTest < Minitest::Test


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
  
  def test_as_title
    assert_equal "\n  ===========\n   MON TITRE\n  ===========", "Mon Titre".as_title
    assert_equal "\n-----------\n MON TITRE\n-----------", "Mon Titre".as_title('-', 0)
  end

  def test_columnize_class_method
    # -- avec un string --
    string = "Pour voir ce,que ça donne\nEn colonnisant,le texte"
    actual = String.columnize(string)
    expect = <<~TEXT.strip
    Pour voir ce      que ça donne
    En colonnisant    le texte
    TEXT
    assert_equal expect, actual

    string = "A1, B1, C1, D1\nA2,B2,Cdeux,D2\nAtrois, B3, C3,D3"
    actual = String.columnize(string)
    expect = <<~TEXT.strip
    A1        B1    C1       D1
    A2        B2    Cdeux    D2
    Atrois    B3    C3       D3
    TEXT
    assert_equal actual, expect
  end

  def test_columnize_class_method_with_params
    # Test de columnize avec des paramètres
    assert false # le programmer 
  end

end #class ClirStringExtensionTest

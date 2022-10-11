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

  def test_columnize_class_method_with_other_delimiter
    string = "A1\t B1\t C1\t D1\nA2\tB2\tCdeux\tD2\nAtrois\t B3\t C3\tD3"
    actual = String.columnize(string, "\t")
    expect = <<~TEXT.strip
    A1        B1    C1       D1
    A2        B2    Cdeux    D2
    Atrois    B3    C3       D3
    TEXT
    assert_equal actual, expect
  end

  def test_columnize_class_method_with_other_gutter
    string = "A1\t B1\t C1\t D1\nA2\tB2\tCdeux\tD2\nAtrois\t B3\t C3\tD3"
    actual = String.columnize(string, "\t", '--')
    expect = <<~TEXT.strip
    A1    --B1--C1   --D1
    A2    --B2--Cdeux--D2
    Atrois--B3--C3   --D3
    TEXT
    assert_equal actual, expect
  end

  def test_method_in?
    str = "Bonjour"
    assert_respond_to str, :in?
    assert "Bonjour".in?("Bonjour tout le monde !")
    refute "Bonjour".in?("Il n'y a personne ici")
    assert "Bonjour".in?(['Bonjour','Tout','Le','Monde'])
    refute 'Bonjour'.in?(['bonjour','bONJOUR'])
  end

end #class ClirStringExtensionTest

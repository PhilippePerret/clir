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

  def test_method_numeric?
    str = "Bonjour"
    assert_respond_to str, :numeric?
    refute str.numeric?
    assert "12".numeric?
    assert "12.3".numeric?
    refute "12,3".numeric?
    assert "0".numeric?
    refute "b23".numeric?
    refute "12b".numeric?
  end

  def test_method_normalize
    str = "bonjour"
    assert_respond_to str, :normalize
    [
      ['ça', 'ca'],
      ['Ça', 'Ca'],
      ['Æsitope', 'Aesitope'],
      ['œuf', 'oeuf'],
      ['Bonjour', 'Bonjour'],
    ].each do |str, expected|
      assert_equal expected, str.normalize
    end
    
  end

  def test_method_normalized
    str = "bonjour"
    assert_respond_to str, :normalized
  end

  def test_method_patronize
    str = "bonjour"
    assert_respond_to str, :patronize
    [
      ['bonjour', 'Bonjour'],
      ['marion michel', 'Marion Michel'],
      ['MARION MICHEL', 'Marion Michel'],
      ['mARION mICHEL', 'Marion Michel'],
      ['marion michel-aliot', 'Marion Michel-Aliot'],
      ['MARION DE MICHEL', 'Marion de Michel'],
      ['HUBERT-FÉLIX THIÉFAINE', 'Hubert-Félix Thiéfaine']
    ].each do |str, expected|
      assert_equal expected, str.patronize
    end
  end


  def test_titlize
    str = "bonjour"
    assert_respond_to str, :titleize
    [
      ["bonjour", "Bonjour"],
      ["marion michel", "Marion Michel"],
      ["marion de michel", "Marion De Michel"],
      ["mARION DE MICHEL", "Marion De Michel"]
    ].each do |str, expected|
      assert_equal expected, str.titleize
    end
  end

  def test_camelize
    str = "bonJour"
    assert_respond_to str, :camelize
    [
      ["bonjour", "Bonjour"],
      ["bonjour_tout_le_monde", "BonjourToutLeMonde"],
      ["bonjour tout le monde", "Bonjour tout le monde"]
    ].each do |str, expected|
      assert_equal expected, str.camelize
    end
  end

  def test_decamelize
    str = "bonJour"
    assert_respond_to str, :decamelize
    [
      ["Bonjour", "bonjour"],
      ["BonjourToutLeMonde", "bonjour_tout_le_monde"],
      ["bonjour tout le monde", "bonjour tout le monde"],
      ["BonjourTout leMonde", "bonjour_tout le_monde"]
    ].each do |str, expected|
      assert_equal expected, str.decamelize
    end
  end

  def test_cjust
    str = "good"
    assert_respond_to str, :cjust
    [
      ["good", 4, "good"],
      ["good", 4, "good", '+'],
      ["good", 2, "go"],
      ["good", 5, "good "],
      ["good", 6, " good "],
      ["good", 8, "--good--", '-'],
      ["good", 9, "  good   "]
    ].each do |str, len, expected, remp|
      actual = if remp.nil?
        str.cjust(len)
      else
        str.cjust(len, remp)
      end
      assert_equal expected, actual, "#{str.inspect}.cjust(#{len}, #{remp.inspect}) devrait retourner #{expected.inspect}, il retourne #{actual.inspect}."
    end
  end

  STRINGS_SHORTENS = [
      # Jusqu'à 8 on met "…" à la fin
      ["string"                 ,  2, "s…"],
      ["s"                      ,  2, "s"],
      ["se"                     ,  2, "se"],
      ["string"                 ,  3, "st…"],
      ["s"                      ,  3, "s"],
      ["se"                     ,  3, "se"],
      ["set"                    ,  3, "set"],
      ["string"                 ,  4, "str…"],
      ["s"                      ,  4, "s"],
      ["se"                     ,  4, "se"],
      ["set"                    ,  4, "set"],
      ["sete"                   ,  4, "sete"],
      ["string"                 ,  5, "stri…"],
      ["string"                 ,  6, "string"],
      ["strange"                ,  6, "stran…"],
      ["string"                 ,  7, "string"],      # plus petit
      ["strange"                ,  7, "strange"],     # égal
      ["stranger"               ,  7, "strang…"],     # plus grand
      ["Une longue phrase"      ,  7, "Une lo…"],     # beaucoup plus grand
      ["string"                 ,  8, "string"],      # plus petit
      ["stranger"               ,  8, "stranger"],    # égal
      ["strangers"              ,  8, "strange…"],    # plus grand
      ["Une longue phrase"      ,  8, "Une lon…"],    # beaucoup plus grand
      ["string"                 ,  9, "string"],      # plus petit
      ["strangers"              ,  9, "strangers"],   # égal
      ["Une longue phrase"      ,  9, "Une long…"],   # beaucoup plus grand
      ["lie"                    , 10, "lie"],         # plus petit
      ["strange lo"             , 10, "strange lo"],   # égal
      ["strange los"            , 10, "strange l…"],
      # de 11 à 15, on ajoute un '…' au milieu
      ["hippopotames"           , 10, "hippopota…" ],
      ["hippopotame"            , 11, "hippopotame" ],
      ["hippopotames"           , 11, "hippo…tames" ],
      ["stringe"                , 12, "stringe"],
      ["hippopotames"           , 12, "hippopotames" ],
      ["Une longue phrase"      , 12, "Une lo…hrase"], # beaucoup plus grand
      # À partir de 16
      #   SI différence < 4 on ajoute '…' au milieu
      ["Une longue phrase"      , 16, "Une long… phrase"],
      #   SI différence > 4 on ajoute '[…]' au milieu
      ["Une trop longue phrase" , 16, "Une tr[…] phrase"],
      ["Une trop longue phrasée", 16, "Une tr[…]phrasée"],
    ]
  def test_max
    str = "unstring"
    assert_respond_to str, :max
    assert_instance_of String, str.max(10)

    # Argument errors
    assert_raises(ArgumentError) { str.max }
    e = assert_raises(ArgumentError) { str.max(1) }
    actual   = e.message
    expected = "Minimum length should be 2. You give 1."
    assert_equal(expected, actual)
    e = assert_raises(ArgumentError) { str.max("1") }
    assert_equal("Argument should be a Integer", e.message)
    e = assert_raises(ArgumentError) { str.max(1.0) }
    assert_equal("Argument should be a Integer", e.message)
    assert_silent { str.max(10) }

    STRINGS_SHORTENS.each do |str, len, expected|
      actual = str.max(len)
      assert_equal expected, actual, "#{str.inspect}.max(#{len}) should be #{expected.inspect}. It is #{actual.inspect}"
    end
  end

  def test_max_exclamation
    str = "unstring"
    assert_respond_to str, :max!
    assert_instance_of TrueClass, str.max!(10)
    # - Arguments error -
    assert_raises(ArgumentError) { str.max! }
    e = assert_raises(ArgumentError) { str.max!(1) }
    expected = "Minimum length should be 2. You give 1."
    actual   = e.message
    assert_equal(expected, actual)
    assert_silent { str.max!(10) }

    # - Tests -
    STRINGS_SHORTENS.each do |str, len, expected|
      str_ini = "#{str}".freeze
      res = str.max!(len)
      assert res, "max! should return true"
      assert_equal expected, str, "#{str_ini.inspect}.max(#{len}) should be #{expected.inspect}. It is #{str.inspect}"
    end
  end

end #class ClirStringExtensionTest

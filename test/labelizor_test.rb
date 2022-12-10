require 'test_helper'

class LabelizorTest < Minitest::Test

  def test_tableizor_exist
    assert defined?(Labelizor)
    assert_equal Class, Labelizor.class
  end

  def test_initialization
    tbl = Labelizor.new
    assert_instance_of Labelizor, tbl
  end

  def test_default_values
    tbl = Labelizor.new
    conf = tbl.config
    {
      gutter: 4,
      indentation: 2,
      separator: ' ',
      delimitor_size: nil,
      delimitor_char: '=',
      title_delimitor: '*',
      delimitor_color: nil,
      titre_color: :bleu
    }.each do |k, v|
      if v.nil?
        assert_nil conf[k], "La propriété de configuration #{k.inspect} devrait être nil"
      else
        assert_equal v, conf[k], "La propriété de configuration #{k.inspect} devrait valoir #{v.inspect}, elle vaut #{conf[k].inspect}."
      end
    end
  end

  def test_empty_table
    tbl = Labelizor.new
    out, err = capture_io { tbl.display }
    out = out.strip
    assert '', out
  end

  def test_table_with_only_a_title
    tbl = Labelizor.new(titre: "Ma belle table", titre_color: nil)
    out, err = capture_io { tbl.display }
    exp = "****************\n   Ma belle table\n  ****************"
    assert_equal exp, out.strip, "Avec seulement un titre, la sortie devrait afficher le titre correctement"
  
    tbl = Labelizor.new(titre: "Table", titre_color: nil, title_delimitor: '-')
    out, err = capture_io { tbl.display}
    exp = "\n  -------\n   Table\n  -------\n\n\n\n"
    assert_equal exp, out, "Le titre devrait être bon avec un autre délimiteur de titre"
  end

  def test_table_with_rows
    tbl = Labelizor.new
    tbl.w "LIBELLÉ", "VALUE"
    out, err = capture_io { tbl.display }
    exp = "\n\n  LIBELLÉ   VALUE\n\n\n"
    assert_equal exp, out, "L'affichage de la ligne devrait être correct"
  end

  def test_table_conditional_display
    tbl = Labelizor.new
    (1..10).each do |i|
      tbl.w "Résultat", i.to_s, if: i.odd?
    end
    out, err = capture_io { tbl.display }
    exp = "\n\n  Résultat   1\n  Résultat   3\n  Résultat   5\n  Résultat   7\n  Résultat   9\n\n\n"
    assert_equal exp, out, "L'affichage conditionnel devrait fonctionner."
  end

  def test_changement_gutter
    skip "à implémenter"
  end

  def test_changement_indentation
    skip "à implémenter"
  end

  def test_changement_couleurs
    skip "à implémenter"
  end


end #/Minitest

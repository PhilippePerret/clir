require 'test_helper'

# Utile pour tester l'affichage avec unité
def affyen(value)
  "#{value}¥"
end

class CliTableTester < Minitest::Test

  def tbl(params = nil)
    @table = Clir::Table.new(params)
  end

  def add(foo)
    @table << foo
  end

  def output
    o, _ = capture_io { @table.display }
    return o
  end

  def test_existance
    assert defined?(Clir::Table)
    assert_instance_of Class, Clir::Table
    assert_instance_of Clir::Table, tbl
  end

  def test_options_with_header
    # 
    # En utilisant les valeurs par défaut
    # 
    tbl(header: ['UN', 'DEUX', 'TROIS'])
    exp = "    UN    DEUX    TROIS  \n  ***********************\n  ***********************\n\n\n"
    assert_equal exp, output, "L'affichage de la table n'est pas bon"
  
    #
    # En modifiant la gouttière
    # 
    tbl(header: ['UN', 'DEUX', 'TROIS'], gutter: 2)
    exp = "    UN  DEUX  TROIS  \n  *******************\n  *******************\n\n\n"
    assert_equal exp, output, "L'affichage de la table n'est pas bon"

    #
    # En modifiant le séparateur
    # 
    tbl(header: ['UN', 'DEUX', 'TROIS'], gutter: 4, char_separator: '+')
    exp = "    UN    DEUX    TROIS  \n  +++++++++++++++++++++++\n  +++++++++++++++++++++++\n\n\n"
    assert_equal exp, output, "L'affichage de la table n'est pas bon"

    #
    # En modifiant l'indentation
    # 
    tbl(header: ['UN', 'DEUX', 'TROIS'], gutter: 4, char_separator: '+', indent: 3)
    exp = "     UN    DEUX    TROIS  \n   +++++++++++++++++++++++\n   +++++++++++++++++++++++\n\n\n"
    assert_equal exp, output, "L'affichage de la table n'est pas bon"

  end



  def test_with_one_row
    tbl(header: ['Un','Deux','Trois'])
    add ["Première", "Deuxième", "Troisième"]
    exp = [
      "    Un          Deux        Trois      ",
      "  *************************************",
      "    Première    Deuxième    Troisième  ",
      "  *************************************"
    ].join("\n").rstrip

    out = output.rstrip
    # puts "OUT:\n#{out.inspect}"
    # puts "EXP:\n#{exp.inspect}"
    assert_equal exp, out, "L'affichage de la rangée n'est pas bon"
  end

  def test_with_rows
    tbl(header: ['Un','Deux','Trois'])
    add ["Première", "Deuxième", "Troisième"]
    add ["Cousin", "Cousine", "Moustique"]
    add ["Voisin", "Voisine", "Cuisine"]
    add ["Choix", "A", "Porcelaine"]
    exp = [
      "    Un          Deux        Trois       ",
      "  **************************************",
      "    Première    Deuxième    Troisième   ",
      "    Cousin      Cousine     Moustique   ",
      "    Voisin      Voisine     Cuisine     ",
      "    Choix       A           Porcelaine  ",
      "  **************************************"
    ].join("\n").rstrip

    out = output.rstrip
    # puts "OUT:\n#{out}"
    # puts "EXP:\n#{exp}"
    assert_equal exp, out, "L'affichage de la rangée n'est pas bon"
  end

  def test_rows_with_alignment
    tbl(header: ['Un','Deux','Trois'], align: {right:[2]})
    add ["Voisin", "Voisine", "Cuisine"]
    add ["Choix", "A", "Porcelaine"]
    exp = [
      "    Un        Deux       Trois       ",
      "  ***********************************",
      "    Voisin    Voisine    Cuisine     ",
      "    Choix           A    Porcelaine  ",
      "  ***********************************"
    ].join("\n").rstrip

    out = output.rstrip
    # puts "OUT:\n#{out}"
    # puts "EXP:\n#{exp}"
    assert_equal exp, out, "L'affichage de la rangée n'est pas bon"
  end

  def test_colonnes_a_total
    tbl(header:['Mars','Avril', 'Juin'], colonnes_totaux:{1 => nil, 2 => nil, 3 => nil })
    add [1, 2, 3]
    add [3, 2, 1]
    exp = [
      "    Mars    Avril    Juin  ",
      "  *************************",
      "    1       2        3     ",
      "    3       2        1     ",
      "  *************************",
      "    4       4        4     ",
      "  *************************"
    ].join("\n")
    out = output.rstrip
    # puts "OUT:\n#{out}"
    assert_equal exp, out, "L'affichage avec colonnes de totaux devrait être bon"
  end

  def test_total_colonnes_a_total_et_devise
    tbl(
      title:  "Tableau avec devises",
      header:['Mars','Avril', 'Mai','Juin'],
      char_separator: '=',
      indent: 4,
      align: {right: [4]},
      colonnes_totaux:{1 => :"€" , 2 => :affyen, 3 => '$', 4 => Proc.new {|v| €(v, true)}})
    add [1, 2, 3.1, 5]
    add [3, 2, 1.4, 5.2]
    exp = [
      "    = TABLEAU AVEC DEVISES =",
      "    =====================================",
      "      Mars    Avril    Mai      Juin     ",
      "    =====================================",
      "      1 €     2¥       3.1 $     5.00 €  ",
      "      3 €     2¥       1.4 $     5.20 €  ",
      "    =====================================",
      "      4 €     4¥       4.5 $    10.20 €  ",
      "    ====================================="
    ].join("\n")
    out = output.rstrip
    # puts "OUT:\n#{out}"
    assert_equal exp, out, "L'affichage avec colonnes de totaux devrait être bon"
  end

  def test_column_max_width_with_array
    tbl(
      header:['Septembre', 'Octobre', 'Novembre'],
      max_widths: [4, 5, 6],
    )
    add ["Barnabé", "Colophane", "Brugnions"]
    add ["Rose", "Singe", "Citron"]
    add ["Rot", "Si", "Cire"]
    exp = [
      "    Sep…    Octo…    Novem…  ",
      "  ***************************",
      "    Bar…    Colo…    Brugn…  ",
      "    Rose    Singe    Citron  ",
      "    Rot     Si       Cire    ",
      "  ***************************"
    ].join("\n")
    out = output.rstrip
    assert_equal exp, out, "L'affichage avec limitation de la largeur des colonnes devrait être bon"
  end

  def test_column_max_width_with_hash
    tbl(
      header:['Septembre', 'Octobre', 'Novembre'],
      max_widths: {1 => 4, 2 => 5, 3 => 6},
    )
    add ["Barnabé", "Colophane", "Brugnions"]
    add ["Rose", "Singe", "Citron"]
    add ["Rot", "Si", "Cire"]
    exp = [
      "    Sep…    Octo…    Novem…  ",
      "  ***************************",
      "    Bar…    Colo…    Brugn…  ",
      "    Rose    Singe    Citron  ",
      "    Rot     Si       Cire    ",
      "  ***************************"
    ].join("\n")
    out = output.rstrip
    assert_equal exp, out, "L'affichage avec limitation de la largeur des colonnes devrait être bon"
  end

  def test_column_max_width_with_integer
    tbl(
      header:['Septembre', 'Octobre', 'Novembre'],
      max_widths: 4,
    )
    add ["Barnabé", "Colophane", "Brugnions"]
    add ["Rose", "Singe", "Citron"]
    add ["Rot", "Si", "Cire"]
    exp = [
      "    Sep…    Oct…    Nov…  ",
      "  ************************",
      "    Bar…    Col…    Bru…  ",
      "    Rose    Sin…    Cit…  ",
      "    Rot     Si      Cire  ",
      "  ************************"
    ].join("\n")
    out = output.rstrip
    assert_equal exp, out, "L'affichage avec limitation de la largeur des colonnes devrait être bon"
  end

end #/class CliTableTester

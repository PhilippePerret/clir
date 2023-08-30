require 'test_helper'
require 'date'

class CVSExtensionTest < Minitest::Test

  DO_NOT_ERASE_HUGE_CSV_FILE = false # true # Mettre à false en temps normal et à true quand on travaille ce test

  def setup
    super
    if !DO_NOT_ERASE_HUGE_CSV_FILE
      File.delete(huge_file_csv) if File.exist?(huge_file_csv)
    end
  end

  def teardown
    if !DO_NOT_ERASE_HUGE_CSV_FILE
      File.delete(huge_file_csv) if File.exist?(huge_file_csv)
      File.delete(small_file_csv) if File.exist?(small_file_csv)
    end
  end

  def huge_file_csv
    @huge_file_csv ||= File.expand_path(File.join(__dir__,'huge_file.csv'))
  end
  def small_file_csv
    @small_file_csv ||= File.expand_path(File.join(__dir__,'small_file.csv'))
  end

  def build_huge_csv_file
    return if File.exist?(huge_file_csv)
    puts "Fabrication d'un énorme fichier CSV… Merci de votre patience.".bleu
    File.open(huge_file_csv,'wb') do |f|
      f.puts "Iteration,Date,Indice,Note"
      1000000.times do |i|
        f.puts("#{i},#{Time.now.to_f},#{i+1},Une note pour avoir une ligne quand même assez grande")
      end
    end    
  end

  def build_small_file_csv
    return if File.exist?(small_file_csv)
    File.open(small_file_csv,'wb') do |f|
      f.puts "Iteration,Date,Indice,Note"
      10.times do |i|
        f.puts("#{i},#{Time.now.to_f},#{i+1},Une note pour avoir une ligne quand même assez grande")
      end
    end    
  end

  # On s'assure que les choses dans CSV fonctionnent comme on
  # s'y attend avec les converteurs d'entête (nom des colonnes) et de
  # données.
  def test_backward_compatibility
    table = CSV.parse("Nom,Prénom\n")
    assert_equal(Array, table.class, "La table devrait être de classe Array")
    assert_equal([['Nom','Prénom']], table)

    table = CSV.parse("Nom,Prénom\n", **{headers:true})
    assert_equal(CSV::Table, table.class, "La table devrait être de classe CSV::Table")
    assert_equal(['Nom','Prénom'], table.headers)

    table = CSV.parse("Nom,Prénom\n", **{headers:true, header_converters: :downcase})
    assert_equal(['nom','prénom'], table.headers)

    table = CSV.parse("Nom,Prénom,Prenom\n", **{headers:true, header_converters: :symbol})
    assert_equal([:nom,:prnom,:prenom], table.headers)

    options = {headers:false, converters: []}
    table = CSV.parse("Nombre,String,Date\n10,'10',2023-08-30\n9,'9',2023-08-31", **options)
    assert_equal(["10","'10'",'2023-08-30'], table[1])

    options = {headers:false, converters: [:numeric]}
    table = CSV.parse("Nombre,String,Date\n10,'10',2023-08-30\n9,'9',2023-08-31", **options)
    assert_equal([10,"'10'","2023-08-30"], table[1])
    
    options = {headers:false, converters: %i[numeric date]}
    table = CSV.parse("Nombre,String,Date\n10,'10',2023-08-30\n9,'9',2023-08-31", **options)
    assert_equal([10,"'10'",Date.parse("2023-08-30")], table[1])
  end

  def test_realines_backwards
    assert_respond_to CSV, :readlines_backward
    assert_respond_to CSV, :foreach_backward
    assert_respond_to CSV, :readlines_backwards
    assert_respond_to CSV, :foreach_backwards
  end

  def test_conversion_headers
    build_huge_csv_file

    options = {headers:true}
    CSV.readlines_backward(huge_file_csv, **options) {|row| break }
    assert_equal(["Iteration","Date","Indice","Note"], CSV.headers_for_test)

    options = {headers:true, header_converters: :downcase}
    CSV.readlines_backward(huge_file_csv, **options) {|row| break }
    assert_equal(["iteration","date","indice","note"], CSV.headers_for_test)

    options = {headers:true, header_converters: :symbol}
    CSV.readlines_backward(huge_file_csv, **options) {|row| break }
    assert_equal([:iteration,:date,:indice,:note], CSV.headers_for_test)

  end

  def test_realines_backward_with_small_file
    build_small_file_csv
    rows = []
    CSV.readlines_backward(small_file_csv) do |row|
      rows << row
    end
    assert_equal(10+1, rows.count)
    rows.each_with_index do |row, idx|
      break if idx > 9
      expected  = (10 - idx).to_s
      actual    = row[2]
      assert_equal(expected, actual, "La ligne #{idx} (en partant de la fin) devrait avoir l'indice #{expected}. Il vaut #{actual}.")
    end
  end

  def test_readlines_backward_with_headers_in_small_file
    build_small_file_csv
    rows = []
    options = {headers:true}
    CSV.readlines_backward(small_file_csv, **options) do |row|
      rows << row
    end
    assert_equal(10, rows.count)
    rows.each_with_index do |row, idx|
      expected = (10 - idx).to_s
      actual   = row['Indice']
      assert_equal(expected, actual, "La ligne #{idx} (en partant de la fin) devrait porter l'indice #{expected}. Il vaut #{actual}.")
    end
  end

  def test_readlines_backward_with_data_converters_in_small_file
    build_small_file_csv
    rows = []
    options = {headers:true, converters: %i[numeric date]}
    CSV.readlines_backward(small_file_csv, **options) do |row|
      rows << row
    end
    assert_equal(10, rows.count)
    rows.each_with_index do |row, idx|
      expected = 10 - idx # C'est ici que tout se joue : ça reste un nombre
      actual   = row['Indice']
      assert_equal(expected, actual, "La ligne #{idx} (en partant de la fin) devrait porter l'indice #{expected}. Il vaut #{actual}.")
    end
  end


  def test_readlines_backward_with_huge_file
    build_huge_csv_file
    rows = []
    # stop_loop = 0
    CSV.readlines_backward(huge_file_csv) do |row|
      rows << row
      break if rows.count == 4 # on n'en prend que 4
      # break if (stop_loop += 1) > 100
    end
    assert_equal(4, rows.count, "La liste devrait contenir 4 lignes")
    assert_match(/999999 \+ ([0-9.]+) \+ 1000000 \+/, rows[0].join(' + '))
    assert_match(/999998 \+ ([0-9.]+) \+ 999999 \+/, rows[1].join(' + '))
    assert_match(/999997 \+ ([0-9.]+) \+ 999998 \+/, rows[2].join(' + '))
    assert_match(/999996 \+ ([0-9.]+) \+ 999997 \+/, rows[3].join(' + '))
  end


  def test_readlines_backward_with_headers_with_huge_file
    build_huge_csv_file    
    options = {headers: true, header_converters: :symbol, converters:[:numeric]}
    rows = []
    CSV.readlines_backward(huge_file_csv, **options) do |row|
      rows << row
      break if rows.count == 4
    end
    assert_equal(4, rows.count, "La liste devrait contenir 4 lignes")
    [
      [999999, "rows[0][:iteration]"],
      [1000000, "rows[0][:indice]"],
      [999998, "rows[1][:iteration]"],
      [999999, "rows[1][:indice]"],
    ].each do |expected, expression|
      actual = eval(expression)
      # puts "#{expression} = #{actual.inspect}".bleu
      assert_equal(expected, actual, "#{expression} devrait valoir #{expected}. Elle vaut #{actual}…")
    end
  end

  def test_recherche_une_ligne_en_particulier_dans_huge_file
    #
    # Dans ce test, on va rechercher une rangée qui est plutôt à la 
    # fin (> 50 000 = 75000) des deux façons possibles, pour s'assurer
    # que la méthode en commençant par la fin est bien plus rapide.
    # 
    # Par la même occasion on peut s'assurer que les méthodes readlines
    # et readlines_backward fonctionnent bien de la même manière.
    # 
    build_huge_csv_file    
    options = {headers: true, header_converters: :symbol, converters:[:numeric]}
    row_found = nil
    #
    # On commence en lisant normalement
    # 
    STDOUT.write "Attente normale (je lis un énorme fichier)…".vert
    # start_time = Time.now.to_f
    CSV.foreach(huge_file_csv, **options) do |row|
      if row[:iteration] == 750000
        row_found = row and break
      end
    end
    # duree_with_foreach = Time.now.to_f - start_time
    assert(row_found)
    assert_equal(750001, row_found[:indice])
    # exit

    row_found = nil
    # start_time = Time.now.to_f
    CSV.readlines_backward(huge_file_csv, **options) do |row|
      if row[:iteration] == 750000
        row_found = row and break
      end
    end
    # duree_with_readlines_backward = Time.now.to_f - start_time
    assert(row_found)
    assert_equal(750001, row_found[:indice])

    # MALHEUREUSEMENT, POUR LE MOMENT, ÇA N'EST PAS PLUS RAPIDE AVEC BACKWARD…
    # puts "duree_with_readlines_backward : #{duree_with_readlines_backward.inspect}".bleu
    # puts "\nduree_with_foreach : #{duree_with_foreach.inspect}".bleu
    # assert(duree_with_foreach > 2 * duree_with_readlines_backward, "Ça devrait prendre deux fois plus de temps de lire à l'endroit…")

  end

end

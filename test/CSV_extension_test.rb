require 'test_helper'
require 'date'

class CVSExtensionTest < Minitest::Test

  DO_NOT_ERASE_HUGE_CSV_FILE = true # Mettre à false en temps normal et à true quand on travaille ce test

  def setup
    super
  end

  def teardown
    if !DO_NOT_ERASE_HUGE_CSV_FILE
      File.delete(huge_file_csv) if File.exist?(huge_file_csv)
    end
  end

  def huge_file_csv
    @huge_file_csv ||= File.expand_path(File.join(__dir__,'huge_file.csv'))
  end
  def small_file_csv
    @small_file_csv ||= File.expand_path(File.join(__dir__,'small_file.csv'))
  end

  def build_huge_csv_file
    return if File.exist?(huge_file_csv) && DO_NOT_ERASE_HUGE_CSV_FILE
    File.open(huge_file_csv,'wb') do |f|
      f.puts "Iteration,Date,Indice,Note"
      1000000.times do |i|
        f.puts("#{i},#{Time.now.to_f},#{i+1},Une note pour avoir une ligne quand même assez grande")
      end
    end    
  end

  def build_small_file_csv
    return if File.exist?(small_file_csv) && DO_NOT_ERASE_HUGE_CSV_FILE
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
    assert_respond_to CSV, :readlines_backwards
  end

  # def test_conversion_headers

  #   options = {headers:true}
  #   CSV.readlines_backward(huge_file_csv, **options) {|row| break }
  #   assert_equal(["Iteration","Date","Indice","Note"], CSV.headers_for_test)

  #   options = {headers:true, header_converters: :downcase}
  #   CSV.readlines_backward(huge_file_csv, **options) {|row| break }
  #   assert_equal(["iteration","date","indice","note"], CSV.headers_for_test)

  #   options = {headers:true, header_converters: :symbol}
  #   CSV.readlines_backward(huge_file_csv, **options) {|row| break }
  #   assert_equal([:iteration,:date,:indice,:note], CSV.headers_for_test)

  # end

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
    CSV.readlines_backward(huge_file_csv) do |row|
      if row[0] == '5000'
        rows << row
        break
      end
      # break if rows.count == 120
    end
    assert_equal(4, rows.count, "La liste devrait contenir 4 lignes")
    assert_match(/999999 \+ ([0-9.]+) \+ 1000000 \+/, rows[0].join(' + '))
    assert_match(/999998 \+ ([0-9.]+) \+ 999999 \+/, rows[1].join(' + '))
    assert_match(/999997 \+ ([0-9.]+) \+ 999998 \+/, rows[2].join(' + '))
    assert_match(/999996 \+ ([0-9.]+) \+ 999997 \+/, rows[3].join(' + '))
  end


  # def test_readlines_backward_with_headers
  #   build_huge_csv_file    
  #   options = {headers: true}
  #   rows = []
  #   CSV.readlines_backward(huge_file_csv, **options) do |row|
  #     rows << row
  #     break if rows.count == 4
  #   end
  #   assert_equal(4, rows.count, "La liste devrait contenir 4 lignes")
  # end

end

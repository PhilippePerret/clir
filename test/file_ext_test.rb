require 'test_helper'


class FileExtTest < Minitest::Test

  def setup
    super
    File.delete(file_test) if File.exist?(file_test)    
  end

  def teardown
    File.delete(file_test) if File.exist?(file_test)    
  end

  def file_test
    @file_test ||= File.expand_path(File.join('.','monfile'))
  end

  def test_tail_method_exist
    assert_respond_to File, :tail
  end

  def test_append_method_exist
    assert_respond_to File, :append
  end

  def test_append_method_without_file
    refute File.exist?(file_test)
    msg = "Un contenu le #{Time.now}".freeze
    File.append(file_test, msg)
    assert( File.exist?(file_test), "Le fichier #{file_test} devrait exister")
    expected = msg.strip
    actual   = File.read(file_test).strip
    assert_equal(expected, actual, "Le contenu du fichier devrait être #{expected.inspect}…")
  end

  def test_append_method_with_file
    msg_ini = "Un paragraphe\nUn autre paragraphe\n"
    File.write(file_test, msg_ini)
    msg = "Un contenu le #{Time.now}"
    File.append(file_test, msg)
    expected = "#{msg_ini}#{msg}"
    actual = File.read(file_test)
    assert_equal(expected, actual, "Le contenu du fichier devrait être #{expected.inspect}…")
  end

  def test_tail_return_right_result
    
    content = <<~TEXT
    Première ligne.
    Deuxième ligne.
    Troisième ligne.
    Quatrième ligne.
    Cinquième ligne.
    TEXT
    File.write(file_test, content)

    retour    = File.tail(file_test, 2)
    expected  = "Quatrième ligne.\nCinquième ligne."

    assert_equal(expected, retour)
  end

  def test_tail_with_not_enought_lignes
    content = <<~TEXT
    Première ligne.
    Deuxième ligne.
    TEXT
    File.write(file_test, content)

    retour = File.tail(file_test, 100)

    assert_equal("Première ligne.\nDeuxième ligne.", retour)
  end

  def test_tail_with_huge_file
    File.open(file_test,'wb') do |f|
      1000000.times do |i|
        f.puts("Je suis la ligne #{i}")
      end
    end

    retour = File.tail(file_test, 3)
    expected = <<~TEXT.strip
    Je suis la ligne 999997
    Je suis la ligne 999998
    Je suis la ligne 999999
    TEXT

    assert_equal(expected, retour)
  end

  def test_readlines_backward
    # Test de la lecture d'un fichier, ligne par ligne, en partant
    # du bas
    # 

    assert_respond_to File, :readlines_backward

  end

  def test_readlines_backward_with_huge_file
    File.open(file_test,'wb') do |f|
      f.puts "Iteration,Date"
      1000000.times do |i|
        f.puts("#{i},#{}")
      end
    end
    
  end
  def test_realines_backward_with_small_file
    
  end

end #/class FileExtTest

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

end #/class FileExtTest

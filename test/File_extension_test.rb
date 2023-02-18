require 'test_helper'

class ClirFileExtensionTest < Minitest::Test


  def test_affix_method
    assert_respond_to File, :affix
    [
      [File.join("/Users/untel/son_fichier"), "son_fichier"],
      [File.join("/Users/untel/son_fichier.pfb"), "son_fichier"],
      [File.join("undossier/son_fichier.pfb"), "son_fichier"],
      ["affixeseulement.yaml", 'affixeseulement'],
      ['affixeseulement', 'affixeseulement'],
      ['/path/to/affixeseulement.ext', 'affixeseulement']
    ].each do |pth, expected|
      actual = File.affix(pth)
      assert_equal(expected, actual, "File.affix(#{pth.inspect}) devrait retourner #{expected.inspect}. Il retourne #{actual.inspect}.")
    end

  end


end #/Minitest

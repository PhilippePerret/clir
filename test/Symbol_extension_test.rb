require 'test_helper'

class SymbolExtensionTests < Minitest::Test

  def test_methode_in?
    assert_respond_to :symbole, :in?
    assert :symbole.in?([11,:symbole,13])
    refute :symbole.in?([:pas,:dans,:liste])
    assert :symbole.in?({:autre => 'un', :symbole => 'douze', 20 =>'vingt'})
    refute :symbole.in?({:pas => 'un', :dedans => 'vingt'})
    err = assert_raises { :symbole.in?(true) }
    assert_match 'Given: TrueClass', err.message
  end


  def test_camelize
    assert_respond_to :symbole, :camelize
    [
      ['Bonjour', ":bonjour.camelize"],
      ['Bonjour', ":Bonjour.camelize"],
      ['BonJour', ":Bon_Jour.camelize"],
      ['BonJour', ":bon_Jour.camelize"],
      ['BonJour', ":bon_jour.camelize"],
      ['BonJour', ":bon__jour.camelize"],
      ['BonJour', ":__bon__jour.camelize"],
    ].each do |expected, expression|
      actual = eval(expression)
      assert_equal(expected, actual, "L'expression '#{expression}' devrait produit '#{expected}'. Elle produit '#{actual}'…")
    end
  end

end

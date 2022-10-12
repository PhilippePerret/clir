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

end

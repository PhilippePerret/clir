require 'test_helper'

class IntegerExtensionTests < Minitest::Test

  def test_methode_in?
    assert_respond_to 12, :in?
    assert 12.in?([11,13,12])
    refute 12.in?([1,2,14])
    assert 12.in?((10..20))
    refute 12.in?((1..6))
    assert 12.in?({1 => 'un', 12 => 'douze', 20 =>'vingt'})
    refute 12.in?({1 => 'un', 20 => 'vingt'})
    err = assert_raises { 12.in?(true) }
    assert_match 'Given: TrueClass', err.message
  end

end

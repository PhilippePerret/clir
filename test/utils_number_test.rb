require 'test_helper'

class UtilsNumbersMethodsTest < Minitest::Test

  def test_method_euro
    assert defined?(:€)

    [
      [1, nil, "1 €"],
      [1, true, "1.00 €"],
      [1.1, nil, '1.10 €'],
      ["1.1", nil, '1.10 €'],
      [1.127466, nil, '1.13 €'],
      ["1.127466", nil, '1.13 €']
    ].each do |val, cents, exp|
      if cents === nil
        act = €(val)
        assert_equal exp, act, "€(#{val}) devrait valoir #{exp.inspect}, il vaut #{act}"
      else
        act = €(val, cents)
        assert_equal exp, act, "€(#{val},#{cents}) devrait valoir #{exp.inspect}, il vaut #{act.inspect}"
      end
    end
  end

  def test_method_euro_throw_erreur_with_not_number
    err = assert_raises { €("bad") }
    exp = "Bad value. \"bad\" can't be converted to euros."
    assert_equal(exp, err.message, "Le message d'erreur est mauvais")
  end

  def test_method_pc
    assert defined?(pcent)
    [
      [12, "12 %", nil],
      ["12", "12 %", nil],
      [12, "12.0 %", true],
      [12, "12.000 %", 3],
      [12.456, "12.5 %", 1],
      [12.456, "12.46 %", 2],
      ["12.456", "12.46 %", 2],
    ].each do |val, exp, cents|
      if cents === nil
        act = pcent(val)
      else
        act = pcent(val, cents)
      end
      assert_equal exp, act, "pcent(#{val},#{cents}) devrait renvoyer #{exp.inspect}, elle renvoie #{act.inspect}"
    end
  end

  def test_raise_pourcent_method
    err = assert_raises { pcent("bad") }
    exp = "Bad value. \"bad\":String can't be converted to pourcentage."
    assert_equal(exp, err.message, "Le message d'erreur est mauvais")
  end

end #/class Minitest::Test

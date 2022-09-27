=begin

Test de l'extension de la classe Array

=end
require 'test_helper'

class ExtensionArrayTest < Minitest::Test

  def setup
    
  end

  def test_Array_responds_to_pretty_join
    assert_respond_to Array.new, :pretty_join
  end

  def test_Array_pretty_join_with_strings
    ary = ["un", "deux", "trois"]
    exp = "un, deux et trois"
    assert_equal exp, ary.pretty_join
  end

  def test_Array_pretty_join_with_one_string
    ary = ["un"]
    exp = "un"
    assert_equal exp, ary.pretty_join    
  end

  def test_Array_pretty_join_with_two_strings
    ary = ["un", "deux"]
    exp = "un et deux"
    assert_equal exp, ary.pretty_join
  end

  def test_pretty_join_with_number
    ary = [1,2,3]
    exp = "1, 2 et 3"
    assert_equal exp, ary.pretty_join    
  end

  def test_pretty_join_with_strings_and_numbers
    ary = [1,'un', 2, 'deux', 3]
    exp = "1, un, 2, deux et 3"
    assert_equal exp, ary.pretty_join    
  end

end

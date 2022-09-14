require "test_helper"

class MainMethodsTests < Minitest::Test


  def test_true_or_false_method
    assert_equal :TRUE, true_or_false(2 == 2)
    assert_equal :FALSE, true_or_false(2 == 3)
  end


end

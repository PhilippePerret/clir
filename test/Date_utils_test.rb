require 'test_helper'

class DateUtilsTests < Minitest::Test

  def test_ilya
    assert_respond_to Kernel, :ilya
    assert_respond_to Integer, :ago
  end

  def test_time_jj_mm_aaaa_exist
    assert_respond_to Time.new, :jj_mm_aaaa
    assert_respond_to Time.new, :mm_dd_yyyy
  end

  def test_time_jj_mm_aaa
    expected = Time.now.strftime("%d---%m---%Y")
    assert_equal expected, Time.now.jj_mm_aaaa('---')
    expected = Time.now.strftime("%m---%d---%Y")
    assert_equal expected, Time.now.mm_dd_yyyy('---')
  end

  def test_ilya
    expected = (Time.now - 2 * 3600 * 24).jj_mm_aaaa
    assert_equal expected, ilya(2.jours)
    expected = (Time.now)
  end

  def test_ago
    expected = (Time.now - 2 * 3600 * 24).strftime('%m/%d/%Y')
    assert_equal(expected, 2.days.ago )  
  end

end

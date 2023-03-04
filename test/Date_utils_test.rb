require 'test_helper'

class DateUtilsTests < Minitest::Test

  def setup
    super
  end

  # - human_date -

  # def test_human_date
  #   assert_respond_to Kernel, :human_date
  #   assert_respond_to Kernel, :date_humaine
  # end
  def test_human_date_without_args
    # Sans argument, :human_date retourne la date
    # d'aujourd'hui
    now = Time.now
    lemois = MOIS[now.month][:long]
    expected  = "#{now.day} #{lemois} #{now.year}"
    actual    = human_date
    assert_equal(expected, actual, ":human_date devrait retourner #{expected.inspect}, elle retourne #{actual.inspect}…")
    actual    = date_humaine
    assert_equal(expected, actual, ":date_humaine devrait retourner #{expected.inspect}, elle retourne #{actual.inspect}…")  
  end

  def test_human_date_with_date
    expected = "3 mars 2023"
    ladate = Time.new(2023,3,3, 15,3, 26)
    actual    = human_date(ladate)
    assert_equal(expected, actual, ":human_date(<3/03/2023>) devrait retourner #{expected.inspect}, elle retourne #{actual.inspect}…")
    actual    = date_humaine(ladate)
    assert_equal(expected, actual, ":date_humaine(<3/03/2023>) devrait retourner #{expected.inspect}, elle retourne #{actual.inspect}…")  
  end

  def test_human_date_with_option_longueur
    expected = "6 juil. 2023"
    ladate = Time.new(2023, 7,6, 3,3,3)
    actual    = human_date(ladate, **{length: :court})
    assert_equal(expected, actual, ":human_date(<3/03/2023>) devrait retourner #{expected.inspect}, elle retourne #{actual.inspect}…")
    actual    = date_humaine(ladate, **{length: :court})
    assert_equal(expected, actual, ":date_humaine(<3/03/2023>) devrait retourner #{expected.inspect}, elle retourne #{actual.inspect}…")  
  end

  # - ilya -

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

  def test_date_from
    quatorze = Time.new(2022,12,14)
    date_quatorze = Date.new(2022,12,14)
    [
      [quatorze       , quatorze], # Time
      [date_quatorze  , quatorze], # Date
      ["14/12/2022"   , quatorze], # String straight
      ["2022/12/14"   , quatorze], # String reverse
      [quatorze.to_i  , quatorze], # Integer
    ].each do |input, expected|
      actual = date_from(input)
      assert_instance_of Time, actual
      assert_equal expected, actual, "date_from(#{input.inspect}) devrait valeur #{expected.inspect}, il vaut #{actual.inspect}."
    end
  end

  def test_formate_date
    assert defined?(formate_date)
    time  = Time.new(2022,11,21, 11, 7, 12)
    time2 = Time.new(2022,7,11, 12, 11, 13)
    assert_equal("21 11 2022 - 11:07", formate_date(time))
    assert_equal("21 11 2022", formate_date(time, no_time:true, update_format: true))
    # Le même format est appliqué à la suite
    assert_equal('21 11 2022', formate_date(time))
    assert_equal('21 11 2022 - 11:07:12', formate_date(time, seconds:true, update_format:true))
    # Sans format => le même
    assert_equal('11 07 2022 - 12:11:13', formate_date(time2))
    assert_equal('le 21 novembre 2022 à 11 h 07', formate_date(time, **{update_format:true, sentence:true}))
    # Sans format : le même
    assert_equal('11 07 2022 - 12:11', formate_date(time2, **{update_format:true}))
  end

  def test_date_for_file
    now = Time.now
    now_hour = now.strftime('%Y-%m-%d-%H-%M')
    now_day  = now.strftime('%Y-%m-%d')
    hier = Time.now - 24 * 3600

    [
      [nil, nil, nil, now_day],
      [nil, true, nil, now_hour],
      [nil, nil, '+', now.strftime('%Y+%m+%d')],
      [hier, nil, nil, hier.strftime('%Y-%m-%d')],
      [hier, nil, '_', hier.strftime('%Y_%m_%d')],
    ].each do |time, with_hour, delimitor, expected|
      if delimitor.nil?
        if with_hour.nil?
          if time.nil?
            actual = date_for_file
          else
            actual = date_for_file(time)
          end
        else
          actual = date_for_file(time, with_hour)
        end
      else
        actual = date_for_file(time, with_hour, delimitor)
      end

      assert_equal(expected, actual, "date_for_file(#{time.inspect}, #{with_hour.inspect}, #{delimitor.inspect}) devrait valoir #{expected.inspect}, il vaut #{actual.inspect}.")
    end
  end
end

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

  def test_methode_semaine
    assert_respond_to 12, :semaine
    assert_respond_to 12, :semaines
    assert_respond_to 12, :week
    assert_respond_to 12, :weeks
    
    assert_equal 14.jours, 2.semaine
    assert_equal 14.jours, 2.semaines
    assert_equal 14.jours, 2.week
    assert_equal 14.jours, 2.weeks
    
  end

  def test_methode_jour
    assert_respond_to 12, :jour
    assert_respond_to 12, :jours
    assert_respond_to 12, :day
    assert_respond_to 12, :days

    assert_equal 12 * 3600 * 24, 12.jour
    assert_equal 12 * 3600 * 24, 12.jours
    assert_equal 12 * 3600 * 24, 12.day
    assert_equal 12 * 3600 * 24, 12.days

  end

  def test_methode_heure
    assert_respond_to 12, :heure
    assert_respond_to 12, :heures
    assert_respond_to 12, :hour
    assert_respond_to 12, :hours

    assert_equal 12 * 3600, 12.heure
    assert_equal 12 * 3600, 12.heures
    assert_equal 12 * 3600, 12.hour
    assert_equal 12 * 3600, 12.hours
  end

  def test_methode_minute
    assert_respond_to 12, :minute
    assert_respond_to 12, :minutes

    assert_equal 12 * 60, 12.minute
    assert_equal 12 * 60, 12.minutes
  end


end

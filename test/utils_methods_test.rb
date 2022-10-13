require "test_helper"

class UtilsMethodsTests < Minitest::Test

  def test_round_method
    assert_raises(ArgumentError){ round() }
    assert_equal 6, round(12/2)
    assert_equal 3.33, round(10.0 / 3)
    assert_equal 3.3, round(10.0/3, 1)
    assert_equal 3.3333, round(10.0/3, 4)
  end

  def test_true_or_false_method
    assert_equal :TRUE, true_or_false(2 == 2)
    assert_equal :FALSE, true_or_false(2 == 3)
  end


  def test_mkdir_method
    assert defined?(mkdir)
    pth = File.join('.','pour','voir','profond','dément')
    FileUtils.rm_rf(File.join('.','pour')) if File.exist?(pth)
    refute File.exist?(pth)
    res = mkdir(pth)
    assert_equal res, pth
    assert File.exist?(pth)
    assert File.directory?(pth)
    FileUtils.rm_rf(File.join('.','pour')) if File.exist?(pth)
  end

  def test_delete_if_exist
    assert defined?(delete_if_exist)
    dossier = File.join('.','pour','voir')
    fichier = File.join(dossier,'test.txt')
    unknown = File.join(dossier,'any.txt')
    mkdir(dossier)
    File.write(fichier, 'Un simple texte')
    assert File.exist?(dossier)
    assert File.exist?(fichier)
    refute File.exist?(unknown)

    refute delete_if_exist(unknown)
    assert delete_if_exist(fichier)
    refute File.exist?(fichier)
    assert delete_if_exist(File.join('.','pour'))
    refute File.exist?(dossier)
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
    assert_equal('le 21 11 2022 à 11:07', formate_date(time, update_format:true, sentence:true))
    # Sans format : le même
    assert_equal('le 11 07 2022 à 12:11', formate_date(time2))
  end

end

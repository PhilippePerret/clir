require "test_helper"

class UtilsMethodsTests < Minitest::Test


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
end

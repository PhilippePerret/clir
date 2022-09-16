require "test_helper"

class TTYPromptTests < Minitest::Test

  def test_classes_should_exist
    assert defined?(TestTTYMethods)
  end

  def test_Q_class_should_exist_and_respond_to_methods
    assert defined?(Q)
    assert Q.respond_to?(:toggle_mode)
    assert Q.respond_to?(:ask)
    assert Q.respond_to?(:select)
    assert Q.respond_to?(:multiline)
  end

  # On ne peut pas vérifier, malheureusement
  # def test_Q_should_be_the_right_class_outside_tests
  #   ARGV.clear;ARGV << 'macommande'
  #   CLI.init
  #   assert_equal "CLI::RegularTTYPrompt", Q.name
  # end
  # def test_Q_should_be_right_class_with_tests
  #   ARGV.clear;ARGV << 'macommande --test'
  #   CLI.init
  #   assert_equal "CLI::TestTTYPrompt", Q.name
  # end

  def test_Q_receive_inputs_in_test_mode
    ENV['CLI_TEST'] = 'true'
    ENV['CLI_TEST_INPUTS'] = nil
    CLI.init
    assert_equal [], Q.inputs

    ENV['CLI_TEST_INPUTS'] = ["A","B","C"].to_json
    CLI.init
    assert_equal ['A','B','C'], Q.inputs
  end

  def test_Q_ask_method_in_test_mode
    ENV['CLI_TEST'] = 'true'
    ENV['CLI_TEST_INPUTS'] = ["Marion Mic"].to_json
    CLI.init
    res = Q.ask("What's your name?")
    assert_match "Marion", res
    assert res == 'Marion Mic'
  end


  # --- Test du Responder ---

  def new_tty_responder(type, question = 'The question?')
    @tty_responder = nil
    tty_responder(type, question)
  end

  def tty_responder(type = 'ask', question = 'What’s your name?')
    @tty_responder ||= begin
      CLI.init
      TestTTYMethods::Responder.new(Q, type, question)
    end
  end

  def test_Responder_class_exists
    assert defined?(TestTTYMethods::Responder)
  end

  def test_initialisation_Responder
    r = tty_responder
    assert_equal r.class.name, 'TestTTYMethods::Responder'
  end

  def test_responder_respond_to_usual_methods
    r = tty_responder
    # - choices -
    assert r.respond_to? :choices
    leschoix = [{name:'Premier', value:1}, {name:'Deuxième', value:2}]
    r.choices(leschoix)
    assert_equal r.choices, leschoix
    # -choice -
    assert r.respond_to? :choice
    r.choice "Troisième", 3
    r.choice "Quatrième", 4
    thechoix = r.choices
    assert_equal 4, thechoix.count
    assert_equal 'Quatrième', thechoix[3][:name]
    assert_equal 4, thechoix[3][:value]
    # - per_page - (mais ne doit rien faire)
    assert r.respond_to? :per_page
    # - default - 
    assert r.respond_to? :default
    r.default "Valeur par défaut"
    assert_equal 'Valeur par défaut', r.instance_variable_get('@default')
    # - enum - (mais rien à faire)
    assert r.respond_to? :enum
    # - help - (mais rien à faire)
    assert r.respond_to? :help
    # - validate - (mais rien à faire pour le moment)
    assert r.respond_to? :validate
    # - convert - (mais rien à faire)
    assert r.respond_to? :convert
    r.convert do |c|
      # On peut donner la valeur par block
      c.to_i
    end
  end

  ##
  # Pour vérifier que Q.next_input retourne bien la prochaine
  # valeur entrée ou génère une erreur.
  def test_tty_next_input_method
    ENV['CLI_TEST'] = 'true'
    ENV['CLI_TEST_INPUTS'] = nil
    CLI.init
    assert_respond_to Q, :next_input
    # Raise if no more value for input
    assert_raises { Q.next_input }
    # Dont raise if more value
    ENV['CLI_TEST_INPUTS'] = ['A', 'B', 'C'].to_json
    CLI.init
    assert_equal 'A', Q.next_input
    assert_equal 'B', Q.next_input
    assert_equal 'C', Q.next_input
    assert_raises { Q.next_input }
  end

  ##
  # Pour vérifier que la méthode Responder#evaluate, qui 
  # retourne la valeur qu'aurait renvoyé l'utilisateur, fonctionne
  # conformément aux attentes, quel que soit le type de demande (ask,
  # select ou autre).
  #
  def test_tty_responder_response
    r = tty_responder
    assert r.respond_to? :response
  end

  # Q.ask test
  def test_tty_responder_response_with_ask
    ENV['CLI_TEST'] = 'true'
    r = new_tty_responder('ask')
    ENV['CLI_TEST_INPUTS'] = ["Marion MIC", 'default'].to_json
    assert_equal "Marion MIC", r.response
    r.default("MIC Marion")
    assert_equal 'MIC Marion', r.response
  end

  # Q.select test
  def test_tty_responder_response_with_select
    ENV['CLI_TEST'] = 'true'
    r = new_tty_responder('select')
    r.choices([
      {name:'Premier', value:1},
      {name:'Deuxième', value:2},
      {name:'Troisième', value:3}
    ])
    ENV['CLI_TEST_INPUTS'] = ['brute', {name:'Deuxième'}, {item:3}].to_json
    # Litteral value
    assert_equal 'brute', r.response
    # Value by name (item title)
    assert_equal 2, r.response
    # Value by index
    assert_equal 3, r.response
  end


end

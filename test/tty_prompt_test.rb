require "test_helper"

class TTYPromptTests < Minitest::Test

  def test_classes_should_exist
    assert defined?(InputsTTYMethods)
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

  # --- Test des différentes méthodes de premier niveau ---
  #     (=> utilisé dans le programme, comme Q.ask)

  # Inputs permettant d'interrompre le programme
  def test_Q_interrupt_in_test_mode
    ENV['CLI_TEST'] = 'true'
    ENV['CLI_TEST_INPUTS'] = ["Marion Mic", 'CTRL-C'].to_json
    CLI.init
    Q.ask("What's your name?")
    assert_raises SystemExit do 
      Q.ask("What's your âge")
    end
  end

  # Q.ask test
  def test_Q_ask_method_in_test_mode
    ENV['CLI_TEST'] = 'true'
    ENV['CLI_TEST_INPUTS'] = ["Marion Mic"].to_json
    CLI.init
    res = Q.ask("What's your name?")
    assert_match "Marion", res
    assert res == 'Marion Mic'
  end

  # Q.multiline test
  def test_Q_multiline_method_in_test_mode
    ENV['CLI_TEST'] = 'true'
    texte = "Marion Mic\nVit avec\nPhil"
    ENV['CLI_TEST_INPUTS'] = [texte, '^D'].to_json
    CLI.init
    res = Q.multiline("Avec qui vit-elle (menthe) ?")
    assert_equal texte, res
    res = Q.multiline("Are you sur?")
    assert_empty res
  end

  # Q.select test
  def test_Q_select_in_test_mode
    ENV['CLI_TEST'] = 'true'
    ENV['CLI_TEST_INPUTS'] = ['Troisième',{name:'Premier'},{rname:'emi'},{item:2},{index:1}].to_json
    CLI.init
    proc = Proc.new { 
      Q.select("Quel est votre choix") do |q|
        q.choices [{name:'Premier', value:'1er'}, {name:'Deuxième',value:'2e'}]
      end
    }
    res = proc.call
    assert_equal 'Troisième', res # by explicit value
    res = proc.call
    assert_equal '1er', res       # by :name
    res = proc.call
    assert_equal '1er', res       # by :rname
    res = proc.call
    assert_equal '2e', res        # by :item
    res = proc.call
    assert_equal '1er', res       # by :index
  end

  # Q.multi_select test
  def test_Q_multiselect_in_test_mode
    ENV['CLI_TEST'] = 'true'
    ENV['CLI_TEST_INPUTS'] = [
      ['Troisième'],
      {names:['premier','deuxième']},
      {rname:'iè'},
      {rnames:['o','a']},
      {items:[4,2,1]},
      {index:[1,2]}
    ].to_json
    CLI.init
    proc = Proc.new { 
      Q.multi_select("Quels sont vos choix") do |q|
        q.choice 'Premier',   10
        q.choice 'Deuxième',  20
        q.choice 'Troisième', 30
        q.choice 'Quatrième', 40
      end
    }
    res = proc.call
    assert_equal ['Troisième'], res   # explicit value
    res = proc.call
    assert_equal [10,20], res         # by menu names
    res = proc.call
    assert_equal [20,30,40], res      # by menu reg-name
    res = proc.call
    assert_equal [30,40], res         # by menu reg-names
    res = proc.call
    assert_equal [40,20,10], res      # by items
    res = proc.call
    assert_equal [10,20], res         # by index
  end

  def test_Q_slider_in_test_mode
    ENV['CLI_TEST'] = 'true'
    ENV['CLI_TEST_INPUTS'] = ['DEFAULT',10,'13'].to_json
    CLI.init
    res = Q.slider("Quelle valeur ?", {default: 12})
    assert_equal 12, res                          # default value
    assert_equal 10, Q.slider('Quelle valeur ?')  # explicit value
    assert_equal 13, Q.slider('Quelle valeur ?')  # alway a number
  end


  # --- Test du Responder ---

  def new_tty_responder(type, question = 'The question?')
    @tty_responder = nil
    tty_responder(type, question)
  end

  def tty_responder(type = 'ask', question = 'What’s your name?')
    @tty_responder ||= begin
      CLI.init
      InputsTTYMethods::Responder.new(Q, type, question)
    end
  end

  def test_Responder_class_exists
    assert defined?(InputsTTYMethods::Responder)
  end

  def test_initialisation_Responder
    r = tty_responder
    assert_equal r.class.name, 'InputsTTYMethods::Responder'
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
  # valeur entrée ou génère l'erreur voulue.
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

  # Q.multiline test
  def test_tty_responder_response_with_multiline
    ENV['CLI_TEST'] = 'true'
    r = new_tty_responder('multiline')
    texte = "Plusieurs\nlignes\nPour voir"
    ENV['CLI_TEST_INPUTS'] = [texte, "CTRL_D", "CTRL-D", "CTRL D","^D"].to_json
    assert_equal texte, r.response  # texte explicite
    assert_equal '', r.response     # CTRL_D
    assert_equal '', r.response     # CTRL D
    assert_equal '', r.response     # CTRL-D
    assert_equal '', r.response     # ^D
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
    ENV['CLI_TEST_INPUTS'] = ['brute', {name:'Deuxième'}, {item:3}, {rname:'eux'}].to_json
    # Litteral value
    assert_equal 'brute', r.response
    # Value by name (item title)
    assert_equal 2, r.response
    # Value by index
    assert_equal 3, r.response
    # Value by reg-name
    assert_equal 2, r.response
  end

  # Q.yes? test
  def test_tty_responder_response_with_yes
    ENV['CLI_TEST'] = 'true'
    r = new_tty_responder('yes')
    ENV['CLI_TEST_INPUTS'] = ['o','O','ouI','n','c','y','YES',"\n",'TRUE','false', 1, 0].to_json
    assert r.response # 'o'
    assert r.response # 'O'
    assert r.response # 'ouI'
    refute r.response # 'n'
    refute r.response # 'c'
    assert r.response # 'y'
    assert r.response # 'YES'
    assert r.response # "\n"
    assert r.response # 'TRUE'
    refute r.response # 'false'
    assert r.response # 1
    refute r.response # 0
  end

  # Q.multiselect test
  def test_tty_responder_response_with_multiselect
    ENV['CLI_TEST'] = 'true'
    r = new_tty_responder('multi_select')
    r.choices([
      {name:'Premier',  value:10},
      {name:'Deux',     value:20},
      {name:'Trois',    value:30},
      {name:'Quatre',   value:40}
    ])
    ENV['CLI_TEST_INPUTS'] = [['1','2','3'],{names:['premier','trois']},{items:[2,4]}, {rname:'re'}, {rnames:['re','oi']}].to_json
    assert_equal ['1','2','3'], r.response  # explicit
    assert_equal [10,30], r.response        # with :names
    assert_equal [20,40], r.response        # with :items
    assert_equal [10,40], r.response        # with :rname
    assert_equal [10,30,40], r.response     # with :rnames
  end

  # Q.slider test
  def test_tty_responder_response_with_slider
    ENV['CLI_TEST'] = 'true'
    r = new_tty_responder('slider')
    ENV['CLI_TEST_INPUTS'] = ['10', 20].to_json
    assert_equal 10, r.response
    assert_equal 20, r.response
  end

  def test_tty_respond_to_default_name_for_value
    assert_respond_to Q, :default_name_for_value
  end

  def test_default_name_for_value_return_right_value
    liste = [{name:"Un", value: 1}, {name:'deux', value:2}]
    defaut = Q.default_name_for_value(liste, 3)
    assert_nil defaut
    defaut = Q.default_name_for_value(liste, 1)
    assert_equal 'Un', defaut
  end
end

* 0.16.0
  - Ajout du gem FileUtils
* 0.15.2
  - Minibug sur @params fixed
* 0.15.1
  - String#max and String#max!
* 0.14.4
  - :sentence => :verbal in formate_date
* 0.14.3
  - Cosmetic
* 0.14.2
  - Improvement of formate_date
* 0.14.1
  - Improvement of formate_date
* 0.14.0
  - formate_date
  - date_from
  - date_for_file
* 0.13.0
  - String#cjust
  - Alignment in table columns
* 0.11.2
  - Col max width in Clir::Table
* 0.11.1
  - Cosmetic for Clir::Table
* 0.11.0
  - Utils method for number (devise methods)
  - Powerfull Clir::Table
* 0.10.0
  - Date utils methods
  - Yard for documentation
* 0.9.0
  - Methods semaine, jour, heure, minute (et pluriel + anglaises)
* 0.8.0
  - Method camelize
  - Method decamelize
  - Method titleize
* 0.7.1
  - Add colors (backgrounds and foregrounds)
* 0.7.0
  - Add File extension file
  - New method: File.tail
* 0.6.3
  - Fixed bug in TTY::MyPrompt (2)
* 0.6.2
  - Fixed bug in TTY::MyPrompt
* 0.6.1
  - Marker for TTY::MyPrompt to be able to keep interactive mode
  - during the tests.
  - Methods TTY::MyPrompt::set_mode_interactive, TTY::MyPrompt::set_mode_inputs, TTY::MyPrompt::unset_mode_interactive
* 0.6.0
  - Method CLI::set_tests_on_with_marker
  - Method CLI::unset_tests_on_with_marker
  - To universalize the test state.
* 0.5.1
  - Method TTY::MyPrompt.set_mode_inputs (alias)
* 0.5.0
  - Enable to toggle interactive/inputs mode in TTY::MyPrompt
  - current instance. ((efficient))
* 0.4.9
  - Enable to toggle interactive/inputs mode in TTY::MyPrompt
  - current instance. ((inefficient))
* 0.4.8
  - Environment constant 'NO_CLI_TEST_INPUTS' to use TTY-Prompt in
  - regular mode.
* 0.4.7
  - Options :template pour formate_date
* 0.4.6
  - Ajout de la méthode Q.default_name_for_value
* 0.4.5
  - Ajout de la méthode String#patronize
* 0.4.4
  - Ajout de la méthode String#normalize[d]
* 0.4.3
  - Ajout de la méthode round
* 0.4.2
  - Ajout de la méthode String#numeric?
* 0.4.1
  - Ajout de la méthode Symbol#in?
* 0.4.0
  - Ajout des méthodes in? pour String et Integer
* 0.3.1
  - Ajout des méthodes TTY-Prompt yes? et no?
* 0.3.0
  - Remise de TTY-MyPrompt
* 0.2.1
  - 'less' pour les tests (on écrit directement le texte)
* 0.2.0
  - Ajout de méthode String (as_title, columnize, etc.)
* 0.1.8
  - Amélioration de 'clear' (qui sautait une ligne)
* 0.1.7
  - Ajout de la méthode utile 'formate_date'
* 0.1.6
  - Ajout de la couleur vert clair (ligth_green, vert_clair)
* 0.1.5
  - Ajout des méthode CLI.option(key) et CLI.param(key)
* 0.1.4
  - Ajout de la méthode 'require_folder' qui requiert tous les scripts
  - ruby d'un dossier donné en argument.
* 0.1.3
  - Ajout du strike pour barrer du texte, italic pour mettre en
  - italic et underline pour souligner, en console.
* 0.1.1
  - Auto-init CLI (parse) when app calls :options, :params, etc.
* 0.1.0
  - Création du Gem

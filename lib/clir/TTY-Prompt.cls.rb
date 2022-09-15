=begin

  Class CliTTYPrompt

  It exposes +Q+ class (with methods) so you can use:

    `Q.select("Select some vegetables", ...)` 

  This class aims two goals:
  
  * make tests easier with CliTest
  * enable the "redo" command (with '_')

=end
require 'tty-prompt'
require 'json'


module TTY
  class MyPrompt < Prompt

    ##
    # Init Q instance
    #
    def init
      toggle_mode
      @inputs = nil # for testing
    end

    # Méthode qui fait basculer du mode normal au mode test et
    # inversement.
    def toggle_mode
      if test?
        # 
        # Use tests methods instead of usual methods
        # (overwrite them)
        # 
        self.class.include TestTTYMethods
      else
        # 
        # Usual methods
        # (overwrite tests method if any)
        # 
        self.class.include TTY
      end
    end

    ##
    # In test mode, return fake-user inputs (keyboard inputs)
    def inputs
      @inputs ||= begin
        if ENV['CLI_TEST_INPUTS']
          JSON.parse ENV['CLI_TEST_INPUTS']
        else
          []
        end
      end
    end

  end #/class MyPrompt
end

##
# Tests methods for TTY::Prompt
#
# Each method of TTY::Prompt owns its own method in this
# module so it can respond to Q.<method> and return the 'inputs'
# defined in CLITests for user interaction.
# 
module TestTTYMethods
  class CLiTestNoMoreValuesError < StandardError; end

  def ask(*)
    puts "Je suis le ask utilisé en mode test"
  end
  def select(*)
    puts "Je suis le select utilisé en mode test"
  end
end

Q = TTY::MyPrompt.new(symbols: {radio_on:"☒", radio_off:"☐"})


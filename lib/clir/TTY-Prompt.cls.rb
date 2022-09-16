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

  ##
  # Error class raised when there's no more input values to
  # bring back.
  # 
  class CLiTestNoMoreValuesError < StandardError; end

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

  ##
  # @return next fake-user input or raise a error if no more
  # value to return.
  # 
  def next_input
    if inputs.any?
      inputs.shift
    else
      raise CLiTestNoMoreValuesError
    end
  end

  def ask(*args, &block)
    Responder.new(self, 'ask', *args, &block).response
  end
  def select(*)
    puts "Je suis le select utilisé en mode test"
  end


  # --- Class TestTTYMethods::Responder ---

  class Responder

    attr_reader :prompt, :type, :args
    
    ##
    # The input for this responder
    attr_reader :input
    
    def initialize(prompt, type, *args, &block)
      @prompt = prompt
      @type   = type
      @args   = args
      instance_eval(&block) if block_given?
    end

    ##
    # Main method to evaluate the respond to give
    # (the respond that user would have given)
    #
    # @return the fake-user input transformed (for example, if no
    # value has been given, return the default value)
    def response
      @input  = prompt.next_input
      self.send(tty_method)
      return input
    end

    # --- Twin TTY::Prompt methods ---
    # --- They treat input value as needed ---

    def __ask
      if input.is_a?(String) && input.downcase == 'default'
        @input = default_value
      end
    end

    def __select
      return unless input.is_a?(Hash)
      @input =
        if input.key?('name')
          find_in_choices(/^#{input['name']}$/i).first
        elsif input.key?('rname')
          find_in_choices(eval(input['rname'])).first
        elsif input.key?('item') || input.key?('index')
          choices[(input['item']||input['index']) - 1][:value]
        else
          input
        end
    end

    # --- Usefull methods ---

    # @return all values that match +search+ in choices
    def find_in_choices(search)
      @choices.select do |choix|
        choix[:name].match?(search)
      end.map do |choix|
        choix[:value]
      end
    end

    # @return self Twin TTY method
    # p.e. '__ask' ou '__select'
    def tty_method
      @tty_method ||= "__#{type}".to_sym
    end

    # --- Default value ---

    ##
    # @return the default value
    def default_value
      if defined?(@default)
        return @default
      elsif args[-1].is_a?(Hash)
        args.last[:default]
      else
        nil
      end
    end

    # --- Les méthodes communes qui permettent de définir
    #     le répondeur ---

    ##
    # To define and get select choices
    # 
    def choices(vals = nil)
      if vals.nil?
        return @choices
      else
        @choices ||= []
        @choices += vals
      end
    end

    ##
    # For select or multi-select, to add a choice
    # 
    def choice menu, value = nil, options = nil
      @choices ||= []
      @choices << {name:menu, value:value||menu, options:options}
    end

    ##
    # To define the number of items displayed with a
    # select or multiselect
    # 
    def per_page(*args)
      # Rien à faire ici
    end

    ##
    # To define the default value
    # 
    def default(value)
      @default = value
    end

    ##
    # For real TTYPrompt compatibility
    def enum(*args)
      # Ne rien faire
    end

    ##
    # For real TTYPrompt compatibility
    def help(str)
      # Ne rien faire
    end

    ##
    # For real TTYPrompt compatibility
    def validate(*arg, &block)
      # Ne rien faire
      # TODO Plus tard on pourra vérifier les validations aussi
    end

    ##
    # For real TTYPrompt compatibility
    def convert(*arg, &block)
      # Ne rien faire
      if block_given?
        # TODO Plus tard on pourra vérifier les conversions aussi
        # Mais attention : c'est pas forcément donné par block
      end
    end


  end #/class Responder

end #/module TestTTYMethods

Q = TTY::MyPrompt.new(symbols: {radio_on:"☒", radio_off:"☐"})


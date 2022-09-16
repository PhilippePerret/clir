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
      if test? || CLI::Replayer.on?
        # 
        # Use Inputs methods instead of usual methods
        # (overwrite them)
        # 
        self.class.include InputsTTYMethods
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
module InputsTTYMethods

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
      elsif CLI::Replayer.inputs
        CLI::Replayer.inputs
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

  def response_of(type, *args, &block)
    Responder.new(self, type, *args, &block).response
  end

  def ask(*args, &block)
    response_of('ask', *args, &block)
  end
  def multiline(*args, &block)
    response_of('multiline', *args, &block)
  end
  def select(*args, &block)
    response_of('select', *args, &block)
  end
  def multi_select(*args, &block)
    response_of('multi_select', *args, &block)
  end
  def slider(*args, &block)
    response_of('slider', *args, &block)
  end


  # --- Class InputsTTYMethods::Responder ---

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
      if treat_special_input_values
        self.send(tty_method)
      end
      return input
    end

    # --- Special treatment of input values ---

    ##
    # @return false if no more treatment (no send to tty_method
    # below)
    # 
    def treat_special_input_values
      case input.to_s.upcase
      when /CTRL[ _\-]C/, 'EXIT', '^C' then exit 0
      when 'DEFAULT', 'DÉFAUT'
        @input = default_value
        return false
      end
      return true
    end

    # --- Twin TTY::Prompt methods            ---
    # --- They treat input value as required  ---

    def __ask
      # nothing to do (even default value is treated above)
    end

    def __multiline
      case input
      when /CTRL[ _\-]D/, '^D' then @input = ''
      end
    end

    def __select
      return unless input.is_a?(Hash)
      @input =
        if input.key?('name')
          find_in_choices(/^#{input['name']}$/i).first
        elsif input.key?('rname')
          find_in_choices(/#{input['rname']}/).first
        elsif input.key?('item') || input.key?('index')
          choices[(input['item']||input['index']) - 1][:value]
        else
          input
        end
    end

    def __multi_select
      return unless input.is_a?(Hash)
      @input = 
        if input.key?('names')
          find_in_choices(/^(#{input['names'].join('|')})$/i)
        elsif input.key?('items') || input.key?('index')
          (input['items']||input['index']).map { |n| choices[n.to_i - 1][:value] }
        elsif input.key?('rname')
          find_in_choices(/#{input['rname']}/i)
        elsif input.key?('rnames')
          find_in_choices(/(#{input['rnames'].join('|')})/i)
        else
          input
        end
    end

    def __yes
      @input = ['o','y','true',"\n",'1','oui','yes'].include?(input.to_s.downcase)
    end

    def __slider
      @input = input.to_i
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
        return @choices ||= []
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

end #/module InputsTTYMethods

Q = TTY::MyPrompt.new(symbols: {radio_on:"☒", radio_off:"☐"})


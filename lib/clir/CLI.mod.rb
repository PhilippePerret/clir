=begin

  A command line is composed by:

  - app command (for example: 'rake')
  - main command (main_command): firts element not leading with '-'
    dans without '=' (for example: 'build' in 'rake build')
  - options: elements that lead with '-' or '--'
  - params : elments that contain '=' (key=value pairs)
  - components: all other elements

  We can get this elments with:

    CLI.main_command
    CLI.options[:<key>]
    CLI.option(:key)
    CLI.params[:<key>]
    CLI.components[<index>]

  App can define its own short options (to long options) with:

    CLI.set_options_table({short: long, short: long...})

=end
module CLI
class << self

  ##
  # First class method
  # (call it at start-up)
  # 
  def init
    parse(ARGV)
    Q.init if Q.respond_to?(:init)
  end

  ##
  # @return command line options
  # @options is set while parse method. If it is not set, we
  # CLI.init first.
  # 
  def options
    defined?(@options) || self.init
    @options
  end

  # @return option of key +key+
  def option(key)
    options[key.to_sym]
  end

  ##
  # @main command (after command name)
  def main_command
    @main_command || self.init
    @main_command
  end

  ##
  # @return command line parameters
  # 
  def params
    @params || self.init
    @params
  end

  def param(key)
    params[key.to_sym]
  end

  ##
  # @return command line components
  # 'components' are elements of command line that are not options
  # (with leading '-'), that are not parameters (key=value paire) and
  # that are not main_command
  # 
  def components
    @components || self.init
    @components
  end


  ##
  # Command name
  #
  # Don't confuse with 'main command' which is the very first
  # argument in command line
  #
  def command_name
    @command_name ||= begin
      File.basename($PROGRAM_NAME,File.extname($PROGRAM_NAME))
    end
  end

  ##
  # Main method which parse command line to get:
  # - main command
  # - options (leadings with -/--)
  # - parameters (key=value pairs)
  # 
  def parse(argv)
    argv = argv.split(' ') if argv.is_a?(String)
    if replay_it?(argv)
      # 
      # Replay last command (if unable)
      # 
      puts "Je dois apprendre à replayer la commande précédente".jaune
      puts "Pour ça, je dois enregistrer les inputs précédents.".jaune
    else
      # 
      # Regular run
      # 
      reset
      @raw_command_line = ([command_name]+argv).join(' ')
      argv.each do |arg|
        if arg.start_with?('--')
          arg, val = key_and_value_in(arg[2..-1])
          @options.merge!(arg.to_sym => val)
        elsif arg.start_with?('-')
          arg, val = key_and_value_in(arg[1..-1])
          arg = long_option_for(arg)
          @options.merge!(arg.to_sym => val)
        elsif arg.match?('.=.')
          key, val = key_and_value_in(arg)
          @params.merge!(key.to_sym => val)
        elsif @main_command.nil?
          @main_command = arg
        else
          @components << arg
        end
      end
    end
  end

  def set_options_table(table)
    @_app_options_table = table
  end

  ##
  # For Replayer, return data
  def get_command_line_data
    {
      raw_command_line: @raw_command_line,
      command_name:     command_name,
      main_command:     main_command,
      components:       components,
      options:          options,
      params:           params,
      table_short2long_options:  table_short2long_options
    }
  end

  def set_command_line_data(data)
    data.each do |k, v| instance_variable_set("@#{k}", v) end
  end

  private

    def reset
      @main_command = nil
      @components   = [] 
      @options      = {}
      @params       = {}
      Clir::State.reset
      CLI::Replayer.init_for_recording
      @table_short2long_options = nil
    end

    ##
    # @return the long option for +short+
    # 
    def long_option_for(short)
      short = short.to_sym
      if table_short2long_options.key?(short)
        table_short2long_options[short] 
      else
        short
      end
    end

    ##
    # @return conversion table from short option (pe 'v') to
    # long option (pe 'verbose').
    # App can define its own table in CLI.set_options_table
    def table_short2long_options
      @table_short2long_options ||= begin
        {
          :h  => :help,
          :q  => :quiet,
          :v  => :verbose,
          :x  => :debug,
        }.merge(app_options_table)
      end
    end

    ##
    # @return the app table of options conversions
    def app_options_table
      @_app_options_table ||= {}
    end

    ##
    # @return [key, value] in +foo+ if +foo+ contains '='
    #         [foo, default] otherwise
    def key_and_value_in(foo, default = true)
      foo.match?('=') ? foo.split('=') : [foo, default]
    end

    ##
    # @return TRUE if replay character is used and only
    # replay character
    def replay_it?(argv)
      argv.count == 1 && argv[0] == ::Config[:replay_character]
    end
end #/<< self CLI
end #/module CLI

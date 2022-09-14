=begin

  A command line is composed by:

    - main command (main_command): firts element not leading with '-'
      dans without '='
    - options: elements that lead with '-' or '--'
    - params : elments that contain '=' (key=value pairs)
    - components: all other elements

  We can get this elments with:

    CLI.main_command
    CLI.options[:<key>]
    CLI.params[:<key>]
    CLI.components[<index>]

  App can define its own short options (to long options) with:

    CLI.set_options_table({short: long, short: long...})

=end
module CLI
class << self

  attr_reader :main_command, :options, :params, :components

  ##
  # Main method which parse command line to find out :
  # - main command
  # - options (leadings with -/--)
  # - parameters (key=value pairs)
  # 
  def parse(argv)
    argv = argv.split(' ') if argv.is_a?(String)
    reset
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

  def set_options_table(table)
    @_app_options_table = table
  end

  private

    def reset
      Clir::State.reset
      @table_short2long_options = nil
      @main_command = nil
      @components   = [] 
      @options = {}
      @params  = {}
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

end #/<< self CLI
end #/module CLI

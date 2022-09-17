module CLI
class Replayer
class << self

  attr_reader :ison

  ##
  # When the command is not replayed (ie not '_'), CLI initialize
  # the recordings of inputs
  # 
  def init_for_recording
    @inputs = []
  end

  ##
  # @return true if replayer is running
  # (note : it's running when CLI.main_command is '_')
  # 
  def on?
    :TRUE == ison
  end

  ##
  # Start running replayer (with '_' main command)
  def start
    @ison = replayable? ? :TRUE : :FALSE
  end

  def get_input
    @inputs.pop 
  end

  ##
  # Add a {Any} input value (a Hash, a string, an object, etc.)
  def add_input(input)
    @inputs << input
  end

  ##
  # @return last inputs for the same command.
  # Use 'get_input' to get the input in order with 'pop'
  def inputs
    @inputs ||= begin
      replayable? || raise('Can’t load inputs values: this command is not replayable.')
      data[:inputs].reverse
    end
  end

  ##
  # Save inputs at the end of the script
  def save
    table_replay = {
      inputs:       inputs,
      data:         CLI::get_command_line_data
    }
    File.write(last_command_file, Marshal.dump(inputs))
  end

  def data
    @data ||= begin
      load.tap do |table|
        CLI.set_command_line_data(table[:data])
      end
  end

  def load
    Marshal.load(last_command_file)
  end

  ##
  # @return TRUE if there is a replayable command
  # Note: it's a replayable command if it exists a
  # '.<app>_lastcommand' file in current folder
  def replayable?
    File.exist?(last_command_file(CLI.command_name))
  end

  def last_command_file(command_name = nil)
    command_name ||= CLI.command_name
    File.join(commands_folder_path, command_name)
  end

  def commands_folder_path
    @commands_folder_path ||= mkdir(File.join(ENV["HOME"] || ENV["USERPROFILE"],'.chir_last_commands'))
  end

end #/<< self class Replayer
end #/class Replayer
end #/module CLI

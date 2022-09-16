module CLI
class Replayer
class << self

  @@ison = false

  ##
  # @return true if replayer is running
  # (note : it's running when CLI.main_command is '_')
  # 
  def on?
    :TRUE == @ison
  end

  ##
  # Start running replayer (with '_' main command)
  def start
    @ison = replayable? ? :TRUE : :FALSE
  end

  ##
  # @return TRUE if there is a replayable command
  # Note: it's a replayable command if it exists a
  # '.<app>_lastcommand' file in current folder
  def replayable?
    false
  end

  def commands_folder_path
    @commands_folder_path ||= mkdir(File.join(ENV["HOME"] || ENV["USERPROFILE"],'.chir_last_commands'))
  end

end #/<< self class Replayer
end #/class Replayer
end #/module CLI

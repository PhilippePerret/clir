

def verbose?
  Clir::State.verbose?
end

def debug?
  Clir::State.debug?
end

def test?
  Clir::State.test?
end

def help?
  Clir::State.help?
end

def version?
  Clir::State.version?
end

module Clir
class State
class << self 

  def verbose?
    :TRUE == @__isverbose ||= true_or_false(CLI.options[:verbose] === true)    
  end

  def debug?
    :TRUE == @__debugon ||= true_or_false(CLI.options[:debug] === true)
  end

  def test?
    :TRUE == @__teston ||= true_or_false((CLI.options[:test]||CLI.options[:tests]) === true || ENV['CLI_TEST'] == 'true' || ENV['CLI_TESTS'] == 'true' || File.exist?(CLI::MARKER_TESTS_FILE))
  end

  def help?
    :TRUE == @__helpon ||= true_or_false(CLI.options[:help] === true || ['help','aide'].include?(CLI.main_command))
  end

  def version?
    :TRUE == @__versionon ||= true_or_false(CLI.options[:version] === true || ['version'].include?(CLI.main_command))
  end

  def reset
    @__isverbose  = nil
    @__debugon    = nil
    @__teston     = nil
    @__helpon     = nil
    @__versionon  = nil
  end

end #/<< self
end #/class State
end #/module Clir

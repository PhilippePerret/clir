

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


def true_or_false(value)
   value ? :TRUE : :FALSE
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
    :TRUE == @__teston ||= true_or_false(CLI.options[:test] === true || ENV['CLI_TEST'] == 'true' )
  end

  def help?
    :TRUE == @__helpon ||= true_or_false(CLI.options[:help] === true || ['help','aide'].include?(CLI.main_command))
  end

  def reset
    @__isverbose  = nil
    @__debugon    = nil
    @__teston     = nil
    @__helpon     = nil
  end

end #/<< self
end #/class State
end #/module Clir

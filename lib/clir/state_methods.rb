

def verbose?
  Clir::State.verbose?
end

def debug?
  Clir::State.debug?
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

  def reset
    @__isverbose  = nil
    @__debugon    = nil
  end

end #/<< self
end #/class State
end #/module Clir

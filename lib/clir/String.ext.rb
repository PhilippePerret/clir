=begin
  String extension for CLIR
=end

class String
  def strike
    "\033[9m#{self}\033[0m"
  end
  def underline
    "\033[4m#{self}\033[0m"
  end
  def italic
    "\033[3m#{self}\033[0m"
  end
  def bleu
    "\033[0;96m#{self}\033[0m"
  end
  alias :blue :bleu

  def vert
    "\033[0;92m#{self}\033[0m"
  end
  alias :green :vert

  def rouge
    "\033[0;91m#{self}\033[0m"
  end
  alias :red :rouge

  def gris
    "\033[0;90m#{self}\033[0m"
  end
  alias :grey :gris

  def orange
    "\033[38;5;214m#{self}\033[0m"
  end
 
  def jaune
    "\033[0;93m#{self}\033[0m"
  end
  alias :yellow :jaune

  def mauve
    "\033[1;94m#{self}\033[0m"
  end
  alias :purple :mauve

end #/class String

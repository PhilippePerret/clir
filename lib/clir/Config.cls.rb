=begin

  Pour le moment, on met la configuration comme ça, en dur, mais
  plus tard on pourra la modifier pour chaque application.

=end
module CLIR
class Configuration

  def [](key)
    data[key]    
  end

  # TODO
  def data
    {
      replay_character: '_'
    }
  end

end #/class Configuration
end #/module CLIR

# Expose outside
Config = Configuration.new

=begin
  String extension for CLIR
=end

class String

  def self.columnize(lines, delimitor = ',', gutter = '    ')
    # lines = lines.join("\n") if lines.is_a?(Array)
    lines = lines.split("\n") if lines.is_a?(String)
    # 
    # Nombre de colonnes
    # 
    nombre_colonnes = 0
    colonnes_widths = []
    lines = lines.map do |line|
      line.strip.split(delimitor).map {|e| e.strip}
    end.each do |line|
      nb = line.count # nombre de colonnes
      nombre_colonnes = nb if nb > nombre_colonnes
    end
    # 
    # On met le même nombre de colonnes à toutes les lignes
    # 
    lines.map do |line|
      while line.count < nombre_colonnes
        line << ''
      end
      line
    end.each do |line|
      line.each_with_index do |str, col_idx|
        colonnes_widths[col_idx] = 0 if colonnes_widths[col_idx].nil?
        colonnes_widths[col_idx] = str.length if str.length > colonnes_widths[col_idx]
      end
    end.each do |line|
      # 
      # Mettre toutes les colonnes à la même taille
      # 
      line.each_with_index do |str, col_idx|
        line[col_idx] = str.ljust(colonnes_widths[col_idx])
      end
    end

    lines.map do |line|
      line.join(gutter)
    end.join("\n").strip
    
  end

  # @return TRUE if +ary+, as a String or an Array, includes
  # self. If it's an Hash, has key self.
  def in?(ary)
    case ary
    when Array
      ary.include?(self)
    when String
      ary.match?(self)
    when Hash
      ary.key?(self)
    else
      raise "in? waits for a String, an Hash or a Array. Given: #{ary.class}."
    end
  end

  # Si le texte est :
  # 
  #       Mon titre
  # 
  # … cette méthode retourne :
  # 
  #       Mon titre
  #       ---------
  # 
  # 
  def as_title(sous = '=', indent = 2)
    len = self.length
    ind = ' ' * indent
    del = ind + sous * (len + 2)
    "\n#{del}\n#{ind} #{self.upcase}\n#{del}"
  end


  def strike
    "\033[9m#{self}\033[0m"
  end
  def underline
    "\033[4m#{self}\033[0m"
  end
  def italic
    "\033[3m#{self}\033[0m"
  end


  def blanc
    "#{self}"
  end
  alias :white :blanc
  
  def bleu
    "\033[0;96m#{self}\033[0m"
  end
  alias :blue :bleu

  def vert
    "\033[0;92m#{self}\033[0m"
  end
  alias :green :vert

  def vert_clair
    "\033[0;32m#{self}\033[0m"
  end
  alias :ligth_green :vert_clair

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

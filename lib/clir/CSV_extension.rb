require 'csv'
class CSV
class << self

  # Pour pouvoir tester l'entête dans les tests
  attr_reader :headers_for_test

  # Lecture d'un fichier CSV à partir de la fin
  # 
  # Les arguments sont les mêmes que pour readlines
  # 
  # Pour rappel :
  #   +options+ peut contenir
  #     :headers    À true, on tient compte des entêtes et on
  #                 retourne des CSV::Row. Sinon, on retourne une
  #                 Array simple.
  #     :headers_converters 
  #                 Convertisseur pour les noms des colonnes.
  #                 :downcase ou :symbol
  #     :converters
  #                 Liste de convertisseurs pour les données.
  #                 Principalement :numeric, :date
  #     :col_sep
  #                 Séparateur de colonne. Par défaut une virgule.
  # 
  def readlines_backward(path, **options, &block)

    options ||= {}

    file = File.new(path)
    size = File.size(file)

    if size < ( 1 << 16 )
      return readlines_backward_in_small_file(path, **options, &block)
    end

    #
    # Si options[:headers] est true, il faut récupérer la première
    # ligne et la transformer en entête
    # 
    if options[:headers]
      begin
        fileh   = File.open(path,'r')
        header  = fileh.gets
      ensure
        fileh.close
      end
      table = CSV.parse(header, **options)
      headers = table.headers
      @headers_for_test = headers # pour les tests
    end


    if block_given?
      #
      # Les options pour CSV.parse
      # On garde seulement les convertisseurs de données et on met 
      # toujours headers à false (puisque c'est seulement la ligne
      # de données qui sera parser)
      # 
      line_csv_options = {headers:false, converters: options[:converters]}
      #
      # Avec un bloc fourni, on va lire ligne par ligne en partant
      # de la fin.
      # 
      buffer_size = 10000 # disons que c'est la longueur maximale d'une ligne

      #
      # On se positionne de la fin - la longueur du tampo dans le
      # fichier à lire
      # 
      file.seek(-buffer_size, IO::SEEK_END)
      # 
      # Le tampon courant (il contient tout jusqu'à ce qu'il y ait
      # au moins une ligne)
      # 
      buffer = ""
      #
      # On boucle tant qu'on n'interrompt pas (pour le moment)
      # 
      # QUESTIONS
      #   1.  Comment repère-t-on la fin ? En comparant la position
      #       actuelle du pointeur avec 0 ?
      #   2.  Comment met-on fin à la recherche (c'est presque la 
      #       même question)
      while true
        #
        # On lit la longueur du tampon en l'ajoutant à ce qu'on a 
        # déjà lu ou ce qui reste.
        # Celui pourra contenir une ou plusieurs lignes, la première
        # pourra être tronquée
        # 
        buffer = file.read(buffer_size) + buffer
        #
        # Nombre de lignes
        # (utile ?)
        nombre_lignes = buffer.count("\n")
        # 
        # On traite les lignes du buffer (en gardant ce qui dépasse)
        # 
        if nombre_lignes > 0
          # puts "Position dans le fichier : #{file.pos}".bleu
          # puts "Nombre de lignes : #{nombre_lignes}".bleu
          lines = buffer.split("\n").reverse
          #
          # On laisse la dernière ligne, certainement incomplète, dans
          # le tamplon
          # 
          buffer = lines.pop # on ne prend jamais la dernière
          # 
          # Boucle sur les lignes
          # 
          lines.each do |line|
            line = line.chomp
            line_csv = CSV.parse(line, **line_csv_options)
            # puts "line_csv: #{line_csv.inspect}".orange
            yield line_csv
          end
        end
        #
        # On remonte de deux fois la longueur du tampon. Une fois pour
        # revenir au point de départ, une fois pour remonter à la
        # portion suivante, à partir de la position courante, évide-
        # ment
        # 
        file.seek(-2 * buffer_size, IO::SEEK_CUR)
        #
        # Si on se trouve à 0 ou moins, on peut s'arrêter
        # 
        break if file.pos <= 0
        # puts "Nouvelle position dans le fichier : #{file.pos}".bleu
      end
    else
      #
      # Sans bloc fourni, on renvoie tout le code du fichier, en
      # mettant la dernière ligne au-dessus
      # 
      # À vos risques et périls
      self.readlines(path, **options).to_a.reverse
    end

  end
  alias :readlines_backwards :readlines_backward

  # Lecture à l'envers dans un petit fichier
  # 
  def readlines_backward_in_small_file(path, **options, &block)
    if block_given?
      liste2reverse = []
      self.readlines(path, **options).each { |row| liste2reverse << row }
      liste2reverse.reverse.each do |row|
        yield row
      end
    else
      # Lecture toute simple de la table
      return self.readlines(path, **options).to_a.reverse
    end
  end

end #/<< self class CSV
end #/class CSV

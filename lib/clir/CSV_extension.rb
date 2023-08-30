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
    options.key?(:col_sep) || options.merge!(col_sep: ',')

    file = File.new(path)
    size = File.size(file)

    if size < ( 1 << 16 )
      return readlines_backward_in_small_file(path, **options, &block)
    end

    #
    # Si options[:headers] est true, il faut récupérer la première
    # ligne et la transformer en entête
    # @note Cet entête permettra d'instancier les rangées (\CSV::Row)
    # 
    headers = nil
    if options[:headers]
      begin
        fileh   = File.open(path,'r')
        header  = fileh.gets.chomp
      ensure
        fileh.close
      end
      table = CSV.parse(header, **options)
      headers = table.headers
      @headers_for_test = headers # pour les tests
    end


    if block_given?
      #
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
          # le tampon. Elle sera ajoutée à la fin de ce qui précède
          # 
          buffer = lines.pop
          # 
          # Boucle sur les lignes
          # 
          # @note : un break, dans le &block, interrompra la boucle
          # 
          lines.each do |line|
            line = line.chomp

            # Je crois que c'est ça qui prend trop de temps
            # line = "#{header}\n#{line}\n" if options[:headers]
            # puts "line parsée : #{line.inspect}".bleu
            # line_csv = CSV.parse(line, **line_csv_options) 
            # puts "line_csv: #{line_csv.inspect}::#{line_csv.class}".orange
            # yield line_csv[0]
            # 

            # 
            # Convertir les valeurs si des convertisseurs sont
            # définis
            # NOTE : Pour le moment, je reste simple et un peu brut
            # 
            values = line.split(options[:col_sep])
            if options[:converters]
              values = values.collect do |value|
                options[:converters].each do |converter|
                  if converter == :numeric && value.numeric?
                    value = value.to_i and break
                  elsif converter == :date && value.match?(/[0-9]{2,4}/)
                    begin
                      value = Date.parse(value)
                      break
                    rescue nil
                    end
                  end
                end
                value
              end
            end

            row = CSV::Row.new(headers, values)

            yield row
          end
        end
        #
        # On remonte de deux fois la longueur du tampon. Une fois pour
        # revenir au point de départ, une fois pour remonter à la
        # portion suivante, à partir de la position courante, évide-
        # ment
        # 
        new_pos = file.pos - 2 * buffer_size
        if new_pos < 0
          file.seek(new_pos)
        else
          file.seek(- 2 * buffer_size, IO::SEEK_CUR)
        end
        #
        # Si on se trouve à 0, on doit s'arrêter
        # 
        break if file.pos <= 0
        # puts "Nouvelle position dans le fichier : #{file.pos}".bleu
      end
    else
      #
      # Sans bloc fourni, on renvoie tout le code du fichier
      # 
      # À vos risques et périls
      # self.readlines(path, **options).to_a.reverse
      self.foreach(path, **options).reverse
    end

  end
  alias :readlines_backwards  :readlines_backward
  alias :foreach_backward     :readlines_backward
  alias :foreach_backwards    :readlines_backward

  # Lecture à l'envers dans un petit fichier
  # 
  def readlines_backward_in_small_file(path, **options, &block)
    if block_given?
      self.foreach(path, **options).reverse_each do |row|
        yield row
      end
      # liste2reverse = []
      # self.readlines(path, **options).each { |row| liste2reverse << row }
      # liste2reverse.reverse.each do |row|
      #   yield row
      # end
    else
      # Lecture toute simple de la table
      # return self.readlines(path, **options).to_a.reverse
      return self.foreach(path, **options).reverse
    end
  end

end #/<< self class CSV
end #/class CSV

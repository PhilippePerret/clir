# encoding: UTF-8
# frozen_string_literal: true
=begin

  Class Clir::Table
  -----------------
  Construction d'une table en console

  Contrairement à Labelizor qui ne construit des tables qu'à 
  deux colonnes, avec <<< libelle, valeur >>>, cette classe permet
  de construire des affichages à plusieurs colonnes.


  @usage

    # Pour définir la table
    tb = CLITable.new(
      colonnes_totaux: {3 => :euros},
          # On comptera le total de la 3e colonnes et l'on transformera
          # toutes les valeurs en euros (avec la méthode :€)
      header: ["TITRE", "NOMBRE", "REDEVANCE"],
      gutter: 3,
      align:  {right: [3]}
          # La 3e colonne sera alignée à droite (sur le '€' ici)
    )

    # Pour ajouter une ligne
    tb << [titre, nombre, redevance]

    # Pour l'afficher
    tb.display

=end
module Clir
class Table
  attr_reader :params

  attr_reader :column_count

  ##
  # Instanciation
  # 
  # @param  params {Hash}
  # 
  #         Définition générale de la table.
  # 
  #   :colonnes_totaux  {Hash} Table des indices (1-start) des
  #                     colonnes dont il faut faire la somme.
  #                     Avec en clé l'indice réel de la colonne et
  #                     en valeur soit nil pour un nombre normal, 
  #                     soit :euros pour une somme financière.
  #                     Si cette donnée est définie, une nouvelle
  #                     ligne sera ajoutée au bout du tableau avec
  #                     la somme de cette colonne.
  # 
  #   :header   {Array} Entête, nom de chaque colonne. On peut 
  #             utiliser les retours de chariot pour faire deux
  #             lignes.
  #   :gutter   {Integer} Goutière entre chaque colonne. 4 par défaut
  #   :indent   {Integer} Indentation initiale, en nombre d'espaces
  # 
  # 
  #   :char_separator  {String} La caractère pour faire les lignes
  #                     horizontales de séparation. Une étoile par
  #                     défaut.
  # 
  # @option params [Hash] :align  Définition de l'alignement dans les colonnes.
  #                               En clé l'indice 1-start de la colonne, en
  #                               valeur une valeur parmi :right, :left et :center
  # @option params [Array|Hash|Integer] :max_widths 
  #                 Max width for columns. If it's a integer, it's 
  #                 the max width for each column.
  #                 If it's an Array, it's the definition of each
  #                 column in order. For example, [4, 5, 6] means
  #                 4 signs for the first column, 5 for the second
  #                 one and 6 for the third column. Columns without
  #                 max widths must have nil value.
  #                 If it's a Hash, the key is the column index 
  #                 (1-start) and the value is the max lenght in
  #                 signs.
  #                 
  def initialize(params = nil)
    @params = params || {}
    @lines = []
    add_header_lines
  end

  def display
    #
    # On définit l'alignement de chaque colonne
    # 
    define_colonnes_align

    #
    # On fait les totaux des colonnes désignées
    # 
    formate_cells_totaux unless colonnes_totaux.nil?

    # 
    # On mesure les largeurs des colonnes
    # 
    calc_column_widths

    #
    # On ajoute une séparation à la toute fin
    # 
    add(separation)

    #
    # Écriture du titre (if any)
    # 
    traite_titre if @params[:title]

    # 
    # Boucle sur chaque ligne d'entête
    # 
    @header_lines.each do |cols|
      traite_colonnes( cols, is_header = true )
    end
    # 
    # Boucle sur chaque ligne de données
    # 
    @lines.each do |cols|
      traite_colonnes( cols, is_header = false)
    end
    puts "\n\n"
  end


  def traite_titre
    puts "#{indent}#{char_separator} #{params[:title].upcase} #{char_separator}\n#{indent}#{separation}"
  end

  def traite_colonnes(cols, for_header = false)
    line = 
      case cols
      when Array
        '  ' + cols.collect.with_index do |col, idx|
          alignment = for_header ? :ljust : colonne_aligns[idx]
          col = col.to_s
          if col.length > @column_widths[idx]
            col[0...(@column_widths[idx] - 1)] + '…'
          else
            col.to_s.send(alignment, @column_widths[idx])
          end
        end.join(gutter) + '  '
      when :separation  then separation
      when String       then cols
      end
    #
    # Écriture de la ligne
    # 
    puts indent + line    
  end

  def add(ary)
    @lines << ary
  end
  alias :<< :add

  # Building header
  # 
  # On part toujours du principe qu'il y a deux lignes, et si
  # l'une est vide, on n'en met qu'une seule.
  def add_header_lines
    @header_lines = []
    return if params[:header].nil?
    two_lines = false
    line1 = []
    line2 = []
    params[:header].each do |lib|
      lib1, lib2 = 
        if lib.match?("\n")
          two_lines = true
          lib.split("\n")
        else
          ['', lib]
        end
      line1 << lib1
      line2 << lib2
    end
    @column_count = line2.count
    @header_lines << line1 if two_lines
    @header_lines << line2
    @header_lines << :separation
  end

  def table_width
    @table_width ||= @column_widths.sum + (gutter_width * (column_count - 1))
  end

  def separation
    @separation ||= char_separator * (table_width + 4)
  end

  def char_separator
    @char_separator ||= params[:char_separator] || '*'
  end

  def gutter
    @gutter ||= ' ' * gutter_width
  end

  def gutter_width
    @gutter_width ||= params[:gutter] || 4
  end

  def indent
    @indent ||= ' ' * (params[:indent] || 2)
  end

  def align
    @align ||= params[:align]
  end

  def max_widths
    @max_widths ||= params[:max_widths]
  end

  def colonnes_totaux
    @colonnes_totaux ||= params[:colonnes_totaux]
  end

  # Alignement des colonnes
  def colonne_aligns
    @colonne_aligns
  end


  private

    def define_colonnes_align
      # 
      # Par défaut tous les colonnes sont alignés à gauche
      # 
      @colonne_aligns = Array.new(column_count, :ljust)
      return if align.nil?
      align.each do |indice_colonne, alignment|
        @colonne_aligns[indice_colonne - 1] = alignement
      end
    end

    #
    # Note : requis avant de compter la largeur des colonnes, car
    # les totaux peuvent changer la donne
    # 
    def formate_cells_totaux
      #
      # On fait la ligne de total
      # 
      make_totaux_line
      # 
      # On formate toutes les valeurs. Car elles ont été données
      # en nombre (x) et non pas en euros (€(x)) pour pouvoir calcu-
      # ler les totaux.
      # 
      @lines.each do |cols|
        next unless cols.is_a?(Array)
        colonnes_totaux.each do |idx, type|
          real_idx = idx - 1
          case type
          when NilClass
            # Rien à faire
          when Symbol
            cols[real_idx] = send(type, cols[real_idx])
          when Proc
            cols[real_idx] = type.call(cols[real_idx])
          else 
            cols[real_idx] = "#{cols[real_idx]} #{type}"
          end
        end
      end

    end

    # Calc of the column width. Either defined by widthest value or
    # header, either by max_widths option parameter.
    # 
    def calc_column_widths
      #
      # Pour collecter les largeurs de colonnes
      # 
      @column_widths = Array.new(column_count, 0)
      # 
      # Pour savoir si les largeurs maximales sont définies et
      # prendre les valeurs.
      # @rappel : les largeurs peuvent être définies par un integer
      # un Hash ou un Array.
      # 
      maxes = case max_widths
              when Integer 
                Array.new(column_count, max_widths)
              when Hash
                cw = Array.new(column_count, nil)
                max_widths.each do |idx_col, val|
                  cw[idx_col - 1] = val
                end
                cw
              when Array
                max_widths # must be all defined
              else
                Array.new(column_count, nil)
              end
      # 
      # Les largeurs de colonne seraient-elles déjà toutes définies ?
      # 
      zero_found = false
      maxes.each do |width|
        zero_found = true and break if width == 0 || width.nil?
      end
      unless zero_found
        @column_widths = maxes
        return # fini
      end

      # 
      # Boucles sur chaque ligne
      # 
      (@header_lines + @lines).each do |cols|
        next unless cols.is_a?(Array)
        cols.each_with_index do |col, col_idx|
          if maxes[col_idx]
            # 
            # Si la largeur max est définie pour cette colonne
            # @note
            #   Pour le moment, sera répété pour chaque ligne…
            # 
            @column_widths[col_idx] = max_widths[col_idx]
          else
            # 
            # S'il faut prendre la plus large colonne
            # 
            len = col.to_s.length
            @column_widths[col_idx] = len if len > @column_widths[col_idx]
          end
        end
      end   
    end

    def make_totaux_line
      totaux_line = Array.new(column_count, '')
      max_index = colonnes_totaux.keys.min
      totaux_line[max_index - 2] = 'TOTAUX' unless max_index == 1
      colonnes_totaux.each do |idx, type|
        totaux_line[idx - 1] = 0
      end
      @lines.each do |cols|
        colonnes_totaux.each do |idx, type|
          real_idx = idx - 1
          totaux_line[real_idx] += cols[real_idx]
        end
      end
      add(:separation)
      add(totaux_line)
    end
end #/class Table
end #/module Clir

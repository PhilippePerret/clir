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
  #   :align    {Hash}  Définition de l'alignement des colonnes.
  #                     :right => [<index colonnes 1-start>]
  #                     :left  => [<index colonnes 1-start>]
  # 
  #   :char_separator  {String} La caractère pour faire les lignes
  #                     horizontales de séparation. Une étoile par
  #                     défaut.
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
        cols.collect.with_index do |col, idx|
          alignment = for_header ? :ljust : colonne_aligns[idx]
          col.to_s.send(alignment, @column_widths[idx])
        end.join(gutter)
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
    @separation ||= char_separator * table_width
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

  def colonnes_totaux
    @colonnes_totaux ||= params[:colonnes_totaux]
  end

  # Alignement des colonnes
  def colonne_aligns
    @colonne_aligns
  end


  private

    def define_colonnes_align
      @colonne_aligns = Array.new(column_count, :ljust)
      return if align.nil?
      if align.key?(:right)
        align[:right].each do |idx|
          real_idx = idx - 1
          @colonne_aligns[real_idx] = :rjust
        end
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

    def calc_column_widths
      #
      # Pour collecter les largeurs de colonnes
      # 
      @column_widths = []
      # 
      # Boucles sur chaque ligne
      # 
      (@header_lines + @lines).each do |cols|
        next unless cols.is_a?(Array)
        cols.each_with_index do |col, idx|
          len = col.to_s.length
          @column_widths[idx] = len if @column_widths[idx].nil? || len > @column_widths[idx]
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

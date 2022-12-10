# encoding: UTF-8
=begin

  Pour simplifier l'affichage de table à la console.

  @usage

    t = Labelizor.new(<params>)

    t.w "<label>", "<valeur>", <options>
    ...

    t.display # puts 

  NOTES
  =====
    Il y a des options très pratiques comme la propriété :if qui
    permet de n'écrire la ligne que si la condition est vraie. Ça
    permet de ne pas avoir d'identation dans la définition de la
    table.
    Au lieu de :
    
      t.w "Mon label", "Ma valeur"
      if cest_vrai
        t.w "Autre label", "Autre valeur"
      end

    … on utilisera :

      t.w "Mon label", "Ma valeur"
      t.w "Autre label", "Autre valeur", if:cest_vrai

=end

class Labelizor
  attr_reader :lines
  attr_reader :config
  #
  # @param  params {Hash|Nil}
  #   :titre        Le titre à donné au tableau
  #   :titre_color  Couleur à appliquer (bleu par défaut)
  #   :separator    le sépateur, en général une espace mais peut être
  #                 aussi un point
  #   :delimitor_size   {Integer} La longueur par défaut d'une
  #                 ligne délimitant les données.
  #                 On peut définir la longueur d'une ligne à la
  #                 volée avec le 2e paramètres : t.w(:delimitor, 20)
  #   :delimitor_char  {String} Caractère utilisé pour le délimiteur
  #                 Par défaut, un signe '='
  #   :gutter       {Integer} La largeur de la gouttière (4 par défaut)
  #   :indentation  {Integer} Nombre d'espace en indentation (2 par
  #                 defaut)
  #   :selectable   {Boolean} Si true, l'instance rajoute des numéros
  #                 à chaque item et permet à la fin d'en choisir
  #                 un :  value = Labelizor#display
  # 
  def initialize(params = nil)
    defaultize_config(params)
    reset
  end
  def defaultize_config(config)
    @config = config || {}
    @config.key?(:gutter)           || @config.merge!(gutter: 4)
    @config.key?(:indentation)      || @config.merge!(indentation: 2)
    @config.key?(:separator)        || @config.merge!(separator: ' ')
    @config.key?(:delimitor_size)   || @config.merge!(delimitor_size: nil)
    @config.key?(:delimitor_char)   || @config.merge!(delimitor_char: '=')
    @config.key?(:title_delimitor)  || @config.merge!(title_delimitor: '*')
    @config.key?(:delimitor_color)  || @config.merge!(delimitor_color: nil)
    @config.key?(:titre_color)      || @config.merge!(titre_color: :bleu)
  end
  #
  # Pour écrire dans la table
  # 
  # @param  label {String}
  #     Le label. Certaines valeurs spéciales peuvent être utilisées
  #     comme :delimitor (la longueur sera celle définie en second
  #     argument ou celle définie par défaut)
  # @param  value {Any}
  #     La valeur à afficher à droite du label.
  # @param  params {Hash}
  #     Les paramètres à appliquer. C'est là que la méthode prend
  #     tout son sens.
  #     Les valeurs définies peuvent être :
  #       :color    {Symbol} La méthode de couleur (p.e. :vert)
  #       :if       On n'affiche la ligne que si la valeur est true
  # 
  def w(label, value = nil, params = nil)
    params ||= {}
    return if params.key?(:if) && !params[:if]
    # 
    # Traitement de valeur de +label+ spéciales
    # 
    case label
    when :titre, :title
      value = "\n#{value}\n#{'-'*value.length}"
      add_line [:titre, value, params]
    when :delimitor
      params.merge!(color: delimitor_color) unless params.key?(:color)
      add_line([:delimitor, value, params])
    else
      add_line([label || '', value || '', params])
    end
  end
  alias :<< :w

  def reset
    @label_width = nil
    @lines = [] # pour se servir encore de l'instance
    @indent = nil
    @values = [] # pour selectable
  end

  def add_line(dline)
    #
    # Si c'est une table "sélectionnable", il faut ajouter des
    # index pour choisir la valeur
    # 
    if selectable?
      @values << dline[1].freeze
      dline[0] = "#{@values.count.to_s.rjust(3)}. #{dline[0]}"
    end
    # 
    # Ajout de la ligne
    # 
    @lines << dline
  end
  # 
  # Méthode pour afficher la table
  def display
    puts "\n"
    # 
    # Écriture du titre (if any)
    #
    if @config[:titre]
      sep = @config[:title_delimitor] * (@config[:titre].length + 2)
      titre = ("#{indent + sep}\n#{indent + ' ' + @config[:titre]}\n#{indent + sep}")
      titre = titre.send(@config[:titre_color]) unless config[:titre_color].nil?
      puts titre
    end
    puts "\n"
    #
    # Écriture des lignes
    # 
    lines.each do |lab, val, params|
      case lab
      when :titre then lab, val = [val,'']
      when :delimitor
        lab = delimitor_char * delimitor_size(val)
        val = nil
      else
        lab = "#{lab} ".ljust(label_width - 2, config[:separator])
      end
      str = lab + ' ' + formate_value(val, params)
      str = str.send(params[:color]) if params[:color]
      idt = indent(params)
      str = idt + str.split("\n").join("\n#{idt}")
      puts str
    end
    puts "\n\n"
    if selectable?
      wait_for_item_chosen
    end
    reset
  end
  alias :flush :display

  def wait_for_item_chosen
    choix = nil
    nombre_choix = @values.count
    puts "\n"
    while choix.nil?
      STDOUT.write("\rMémoriser : ")
      choix = STDIN.getch.to_i
      if choix > 0 && choix <= nombre_choix
        break
      else
        STDOUT.write "\r                   #{choix} n'est pas compris entre 1 et #{nombre_choix}.".rouge
        choix = nil
      end
    end
    STDOUT.write("\r"+' '*80)
    clip @values[choix.to_i - 1]
    puts "\n\n"    
  end

  def delimitor_color
    @delimitor_color ||= config[:delimitor_color]
  end
  def delimitor_size(value = nil)
    return value unless value.nil?
    @delimitor_size ||= config[:delimitor_size] || (label_width - 1)
  end
  def delimitor_char
    @delimitor_char || config[:delimitor_char]
  end

  def indent(params = {})
    @indent ||= ' ' * config[:indentation]
    case params[:indent]
    when 0        then ''
    when nil      then @indent
    when Integer  then @indent + ' ' * params[:indent]
    when String   then @indent + params[:indent]
    end
  end
  #
  # Formater la valeur en fonction des paramètres
  # 
  def formate_value(val, params)
    return '' if val.nil?
    val = €(val)            if params[:euros]
    val = formate_date(val) if params[:date]
    return val.to_s
  end
  #
  # Calcul de la longueur du label
  # 
  def label_width
    @label_width ||= begin
      maxw = 0; @lines.each do |dline|
        labl = dline[0].length
        maxw = labl if labl > maxw
      end;maxw + config[:gutter]
    end
  end

  def selectable?
    :TRUE == @isselectable ||= true_or_false(@config[:selectable] == true)
  end
end

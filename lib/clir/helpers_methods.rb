# --- Helpers pour console ---

##
# Pour "labeliser" une table de label <> valeur
# 
# @param  ary {Array}
#         Liste des valeurs, sous la forme
#           [
#             ['<label>', '<valeur>'[ :couleur|options]],
#             ['<label>', '<valeur>'[ :couleur|options]],
#             etc,
#           ]
#         Produira :
#             label   valeur
#             label   valeur
#             etc.
# 
#         Le 3e paramètre de chaque item peut définir SOIT la couleur
#         comme un symbole (par exemple :vert), SOIT une table qui
#         peut contenir :
#           color:    La couleur à appliquer
#           detail:   Un texte à ajouter après la valeur (en gris)
# 
# @param  params {Hash|Nil}
#
#         Paramètres définissant la table à obtenir avec :
#
#         :indent       Identation avant le label (soit un nombre
#                       d'espace soit l'indentation elle-même)
#         :gutter       Taille (en espace) de la gouttière entre les
#                       libellés et les valeurs (4 par défaut)
#         :label_width  Pour forcer la taille des libellés. Sinon,
#                       elle sera calculée d'après le plus grand
#                       label.
def labelize(ary, params = nil)
  # 
  # On peut traiter une simple ligne ou un tableau
  # 
  ary = [ary] unless ary.is_a?(Array)
  # 
  # Les paramètres à appliquer
  # 
  params ||= {}
  params.key?(:gutter) || params.merge!(gutter: 4)
  params.key?(:label_width) || begin
    params.merge!(label_width: ary.max { |a,b| a[0].length <=> b[0].length }[0].length + params[:gutter] )
  end
  (params.key?(:indent) && params[:indent]) || params.merge!(indent:'')
  params[:indent] = ' '*params[:indent] if params[:indent].is_a?(Integer)
  # 
  # On construit la ligne ou chaque ligne du tableau
  # 
  ary.collect do |lib, val, options|
    params_line = params.dup
    case options
    when Symbol then params_line.merge!(color: options) 
    when Hash   then params_line.merge!(options)
    end
    params[:indent] + label_value_line(lib, val, params_line)
  end.join("\n")
end
def label_value_line(label, value, params = nil)
  str = "#{label.to_s.ljust(params[:label_width])}#{value}"
  str = str.send(params[:color]) unless params[:color].nil?
  str = str + ' ' + params[:detail].gris if params[:detail]
  return str
end


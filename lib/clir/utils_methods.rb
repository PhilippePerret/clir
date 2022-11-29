# require 'fileutils'

##
# Require all ruby file deep in folder +dossier+
# 
def require_folder(dossier)
  Dir["#{dossier}/**/*.rb"].each{|m|require(m)}
end

##
# Like 'mkdir -p' command
# 
def mkdir(pth)
  FileUtils.mkdir_p(pth)
  return pth
end

##
# Formate de date as JJ MM AAAA (or MM JJ AAAA in english)
# @param {Time} date
# @param {Hash} Options table:
#   :no_time    Only day, without time
#   :seconds    Add seconds with time
#   :update_format    If true, the format is updated. Otherwise, the
#                     last format is used for all next date
#   :sentence   Si true, on met "le ... à ...."
# 
def formate_date(date, options = nil)
  options ||= {}
  @last_format = nil if options[:update_format] || options[:template]
  @last_format ||= begin
    if options[:template]
      options[:template]
    else
      fmt = []
      fmt << 'le ' if options[:sentence]
      fmt << '%d %m %Y'
      delh = options[:sentence] ? 'à' : '-'
      fmt << " #{delh} %H:%M" unless options[:no_time]
      fmt << ':%S' if options[:seconds]
      fmt.join('')
    end
  end
  date.strftime(@last_format)
end

##
# To round a number
# 
def round(n, decim = 2)
  r = n.to_f.round(decim)
  r.to_f == r.to_i ? r.to_i : r.to_f
end

##
# To copy in the clipboard
# 
def clip(ca, silent = false)
  `printf "#{ca.gsub(/"/, '\\"').strip}" | pbcopy`
  silent || puts("\n(“#{ca}“ copié dans le presse-papier)".gris)
end

##
# To delete (unlink) folder of file if it exists
# 
# @return TRUE if file existed (and have been deleted).
# 
def delete_if_exist(pth)
  if File.exist?(pth)
    if File.directory?(pth)
      FileUtils.rm_rf(pth)
    else
      File.delete(pth)
    end
    return not(File.exist?(pth))
  else
    false
  end
end

def true_or_false(value)
  value ? :TRUE : :FALSE
end


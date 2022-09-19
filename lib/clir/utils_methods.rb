# require 'fileutils'

##
# Like 'mkdir -p' command
# 
def mkdir(pth)
  FileUtils.mkdir_p(pth)
  return pth
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


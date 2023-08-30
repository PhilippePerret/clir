class File

  # @return +nline+ last lines of +path+ file without loading the
  # whole content.
  # 
  def self.tail(path, nlines)
    file = open(path, "r")
    buff = 512
    line_count = 0
    # nlines += 1 # to get the last one
    file.seek(0, IO::SEEK_END)

    offset = file.pos # start at the end

    while nlines > line_count && offset > 0
      to_read = if (offset - buff) < 0
                  offset
                else
                  buff
                end

      file.seek(offset - to_read)
      data = file.read(to_read)

      data.reverse.each_char do |c|
        if line_count > nlines
          offset += 1
          break
        end
        offset -= 1
        if c == "\n"
          line_count += 1
        end
      end
    end

    file.seek(offset)
    data = file.read.strip
  ensure
    file.close
  end

  # alias : tail_lines
  def self.readlines_backward(path, &block)
    # 
    # Si le fichier n'est pas trop gros, on le lit à l'envers
    # en le chargeant.
    # 
    if File.size(File.new(path)) < ( 1 << 16 ) 
      self.readlines(path).reverse.each do |line|
        yield line
      end
      return
    end

    #
    # Pour un gros fichier
    # 

    # TODO ON POURRAIT METTRE UN BUFFER MOINS GRAND POUR NE PAS
    # AVOIR DE TROP NOMBREUSES LIGNES EN MÊME TEMPS
    tail_buf_length = 1 << 16 # 65000 et quelques
    file = File.new(path)

    file.seek(-tail_buf_length,IO::SEEK_END)
    out   = ""
    count = 0
    while count <= n # TODO C'EST CETTE BOUCLE QU'IL FAUT DÉVELOPPER JUSQU'EN HAUT
      buf     =  file.read( tail_buf_length )
      count   += buf.count("\n")
      out     += buf
      # 2 * since the pointer is a the end , of the previous iteration
      file.seek(2 * -tail_buf_length,IO::SEEK_CUR)
    end
    # TODO : IL FAUT S'Y PRENDRE MIEUX QUE ÇA POUR TOUT LIRE 
    # CAR MAINTENANT +n+ N'EST PLUS LE NOMBRE DE LIGNES DONNÉES EN
    # ARGUMENT DE LA MÉTHODE tail ORIGINALE
    out.split("\n")[-n..-1].each do |line|
      yield line
    end
  end

  # @return les +n+ dernières lignes d'un fichier
  def tail_lines(n)
    return [] if n < 1
    if File.size(self) < ( 1 << 16 ) 
      tail_buf_length = File.size(self)
      return self.readlines.reverse[0..n-1]
    else 
      tail_buf_length = 1 << 16
    end
    self.seek(-tail_buf_length,IO::SEEK_END)
    out   = ""
    count = 0
    while count <= n
      buf     =  self.read( tail_buf_length )
      count   += buf.count("\n")
      out     += buf
      # 2 * since the pointer is a the end , of the previous iteration
      self.seek(2 * -tail_buf_length,IO::SEEK_CUR)
    end
    return out.split("\n")[-n..-1]
  end



  # @return [String] the affix's file, i.e. the name without the
  # extension.
  # 
  # @example
  #   File.affix("myfile.ext") => "myfile"
  #   File.affix("pth/to/myfile.ext") => "myfile"
  def self.affix(path)
    File.basename(path,File.extname(path))
  end

  ##
  # Add +code+ to file at +fpath+
  # 
  def self.append(fpath, code)
    begin
      open(fpath,'a') { |f| f.write(code) }
    rescue ENOENT
      raise "Folder #{File.dirname(fpath)} doesn't exist. Unable to write #{fpath} file."
    end
  end

end

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

end

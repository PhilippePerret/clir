=begin

  Console method

=end

# To wach (empty) the console
def clear
  # puts "\n" # pour certaines méthodes
  STDOUT.write "\n\033c"
end

# Write +str+ at column +column+ and line +line+
def write_at(str, line, column)
  msg = "\e[#{line};#{column}H#{str}"
  if test?
    puts msg
  else
    STDOUT.write msg
  end
end


# @return column count of the console
def console_width
  `tput cols`.strip.to_i
end

# @return lines count of the console
def console_height
  `tput lines`.strip.to_i
end

# Use 'less' command to display +texte+
def less(texte)
  if help?
    puts texte
  else
    exec "echo \"#{texte.gsub(/\"/,'\\"')}\" | less -r"
  end
end


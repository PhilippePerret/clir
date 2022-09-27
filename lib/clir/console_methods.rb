=begin

  Console method

=end

# To wach (empty) the console
def clear
  puts "\n" # pour certaines méthodes
  STDOUT.write "\033c"
end

# Write +str+ at column +column+ and line +line+
def write_at(str, line, column)
  STDOUT.write "\e[#{line};#{column}H#{str}"
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
  exec "echo \"#{texte.gsub(/\"/,'\\"')}\" | less -r"
end


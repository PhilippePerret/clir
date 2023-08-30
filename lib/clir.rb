=begin

  @usage

    ~~~ruby
    require 'clir'
    CLI.init
    ...
    ~~~

=end
require 'fileutils'
require "clir/version"
require 'clir/String.ext'
require 'clir/CLI.mod'
require 'clir/Array.ext'
require 'clir/Integer.ext'
require 'clir/Symbol.ext'
require 'clir/File_extension'
require 'clir/CSV_extension'
require 'clir/Config.cls'
require 'clir/utils_methods'
require 'clir/utils_numbers'
require 'clir/Date_utils'
require 'clir/helpers_methods'
require 'clir/state_methods'
require 'clir/console_methods'
require 'clir/TTY-Prompt.cls'
require 'clir/Replayer.cls'
require 'clir/Table'
require 'clir/Labelizor'

module Clir
  class Error < StandardError; end
  # Your code goes here...
end

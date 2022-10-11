=begin

  @usage

    ~~~ruby
    require 'clir'
    CLI.init
    ...
    ~~~

=end
require "clir/version"
require 'clir/String.ext'
require 'clir/CLI.mod'
require 'clir/Array.ext'
require 'clir/Integer.ext'
require 'clir/Config.cls'
require 'clir/utils_methods'
require 'clir/helpers_methods'
require 'clir/state_methods'
require 'clir/console_methods'
require 'clir/TTY-Prompt.cls'
require 'clir/Replayer.cls'

module Clir
  class Error < StandardError; end
  # Your code goes here...
end

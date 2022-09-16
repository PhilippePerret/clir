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
require 'clir/utils_methods'
require 'clir/state_methods'
require 'clir/console_methods'
require 'clir/TTY-Prompt.cls'
require 'clir/Replayer.cls'

module Clir
  class Error < StandardError; end
  # Your code goes here...
end

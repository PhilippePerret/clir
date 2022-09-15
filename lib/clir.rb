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
require 'clir/main_methods'
require 'clir/state_methods'
require 'clir/console_methods'
require 'clir/TTY-Prompt.cls'

module Clir
  class Error < StandardError; end
  # Your code goes here...
end

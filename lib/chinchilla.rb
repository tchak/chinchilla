require "chinchilla/version"

require "capybara"
require "colorize"

require "chinchilla/runner"

if defined?(::Rails)
  module Chinchilla
    class Engine < ::Rails::Engine
    end
  end
end

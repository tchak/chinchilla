require "capybara"
require "rocha"
require "chinchilla/runner"

module Chinchilla
  def self.start(options={})
    Runner.start(options)
  end
end

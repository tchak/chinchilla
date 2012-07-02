require "chinchilla/version"
require "chinchilla/test"
require "chinchilla/suite"
require "chinchilla/runner"

module Chinchilla
  class Engine < ::Rails::Engine
  end

  class << self
    attr_accessor :application, :driver, :mounted_at

    def configure
      yield self
    end
  end
end

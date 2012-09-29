require 'chinchilla/runner/example'
require 'chinchilla/runner/test'

module Chinchilla
  class Runner
    def self.run(options={})
      self.new(options).run
    end

    def initialize(options)
      options[:urls] = [options.delete(:url)] if options.has_key?(:url)
      @options = options
    end

    def io
      @io ||= @options[:io] || STDOUT
    end

    def urls
      @urls ||= @options[:urls] || ['/']
    end

    def driver
      @driver ||= @options[:driver] || :poltergeist
    end

    def poltergeist?
      driver == :poltergeist
    end

    def application
      @application ||= @options[:application] || default_application
    end

    def default_application
      defined?(Rails) ? Rails.application : nil
    end

    def tests
      @tests ||= urls.map {|url| Test.new(self, url) }
    end

    def run
      before = Time.now

      io.puts ""
      io.puts dots.to_s
      io.puts ""
      if failure_messages
        io.puts failure_messages
        io.puts ""
      end

      seconds = "%.2f" % (Time.now - before)
      io.puts "Finished in #{seconds} seconds"
      io.puts "#{examples.size} assertions, #{failed_examples.size} failures"
      passed?
    end

    def examples
      tests.map { |test| test.examples }.flatten
    end

    def failed_examples
      examples.select { |example| not example.passed? }
    end

    def passed?
      tests.all? { |test| test.passed? }
    end

    def dots
      tests.map { |test| test.dots }.join
    end

    def failure_messages
      unless passed?
        tests.map { |test| test.failure_messages }.compact.join("\n\n")
      end
    end

    def session
      @session ||= begin
        if poltergeist? && !defined?(Capybara::Poltergeist)
          require "capybara/poltergeist"
        end
        Capybara::Session.new(driver, application)
      end
    end
  end
end

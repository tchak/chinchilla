require 'chinchilla/runner/example'
require 'chinchilla/runner/test_runner'

module Chinchilla
  class Runner
    attr_reader :suite, :io

    def initialize(io=STDOUT)
      @io = io
    end

    def test_runner(test)
      TestRunner.new(self, test)
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
      test_runners.map { |test_runner| test_runner.examples }.flatten
    end

    def failed_examples
      examples.select { |example| not example.passed? }
    end

    def passed?
      test_runners.all? { |test_runner| test_runner.passed? }
    end

    def dots
      test_runners.map { |test_runner| test_runner.dots }.join
    end

    def failure_messages
      unless passed?
        test_runners.map { |test_runner| test_runner.failure_messages }.compact.join("\n\n")
      end
    end

    def session
      @session ||= Capybara::Session.new(Chinchilla.driver, Chinchilla.application)
    end

    def suite
      @suite ||= Chinchilla::Suite.new(Chinchilla.mounted_at)
    end

    protected

    def test_runners
      @test_runners ||= suite.tests.map { |test| TestRunner.new(self, test) }
    end
  end
end

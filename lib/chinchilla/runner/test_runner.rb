module Chinchilla
  class Runner
    class TestRunner
      attr_reader :runner, :test

      def initialize(runner, test)
        @runner = runner
        @test = test
      end

      def session
        runner.session
      end

      def io
        runner.io
      end

      def run
        io.puts dots
        io.puts failure_messages
        io.puts "\n#{examples.size} assertions, #{failed_examples.size} failures"
        passed?
      end

      def examples
        @results ||= begin
          session.visit(test.url)

          previous_results = ""

          session.wait_until(300) do
            dots = session.evaluate_script('Chinchilla.dots')
            io.print dots.sub(/^#{Regexp.escape(previous_results)}/, '')
            io.flush
            previous_results = dots
            session.evaluate_script('Chinchilla.done')
          end

          dots = session.evaluate_script('Chinchilla.dots')
          io.print dots.sub(/^#{Regexp.escape(previous_results)}/, '')

          JSON.parse(session.evaluate_script('Chinchilla.getResults()')).map do |row|
            Example.new(row)
          end
        end
      end

      def failed_examples
        examples.select { |example| not example.passed? }
      end

      def passed?
        examples.all? { |example| example.passed? }
      end

      def dots
        examples; ""
      end

      def failure_messages
        unless passed?
          examples.map { |example| example.failure_message }.compact.join("\n\n")
        end
      end
    end
  end
end

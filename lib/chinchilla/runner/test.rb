module Chinchilla
  class Runner
    class Test
      attr_reader :runner, :url

      def initialize(runner, url)
        @runner = runner
        @url = url
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

      def colorize_dots(dots)
        dots = dots.chars.map do |d|
          case d
          when 'E', 'F'; d.red
          when 'P'; d.yellow
          when '.'; d.green
          else;     d
          end
        end
        dots.join ''
      end

      def examples
        @results ||= begin
          session.visit(url)

          session.execute_script(runner_js)

          dots_printed = 0

          begin
            sleep 0.1
            done, dots = session.evaluate_script('[QUnit.Runner.done, QUnit.Runner.dots]')
            if dots
              io.write colorize_dots(dots[dots_printed..-1])
              io.flush
              dots_printed = dots.length
            end
          end until done

          JSON.parse(session.evaluate_script('QUnit.Runner.getResults()')).map do |row|
            Example.new(row)
          end
        end
      end

      def runner_js
        "(function() {"+File.read(File.expand_path("../runner.js", __FILE__))+"})();"
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

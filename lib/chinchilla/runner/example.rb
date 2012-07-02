module Chinchilla
  class Runner
    class Example
      def initialize(row)
        @row = row
      end

      def passed?
        @row['passed']
      end

      def failure_message
        unless passed?
          msg = []
          msg << "  Failed: #{@row['name']}"
          msg << "    #{@row['message']}"
          msg << "    in #{@row['trace']}" if @row['trace']
          msg.join("\n")
        end
      end
    end
  end
end

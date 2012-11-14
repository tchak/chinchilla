module Chinchilla
  class Runner
    def self.start(options={})
      new(options).run
    end

    attr_reader :reporter

    def initialize(options)
      @options = options
      @reporter = Rocha::Reporter.new(*formatters)
    end

    def url
      @url ||= @options[:url] || '/'
    end

    def driver
      @driver ||= @options[:driver] || :poltergeist
    end

    def poltergeist?
      driver == :poltergeist
    end

    def run
      session.visit(url)

      events_consumed = 0
      done = false
      begin
        sleep 0.1
        events = JSON.parse(session.evaluate_script('window.mocha.getEvents()'))
        if events
          events[events_consumed..-1].each do |event|
            done = true if event['event'] == 'end'
            reporter.process_mocha_event(event)
          end

          events_consumed = events.length
        end
      end until done

      reporter.passed?
    rescue => e
      raise e, "Error communicating with browser process: #{e}", e.backtrace
    end

    def session
      @session ||= begin
        if poltergeist? && !defined?(Capybara::Poltergeist)
          require "capybara/poltergeist"
        end
        Capybara::Session.new(driver, application)
      end
    end

    private

    def application
      @application ||= @options[:application] || default_application
    end

    def formatters
      @formatters ||= @options[:formatters] || default_formatters
    end

    def default_application
      defined?(Rails) ? Rails.application : nil
    end

    def default_formatters
      [Rocha::Formatter.new(STDOUT)]
    end
  end
end

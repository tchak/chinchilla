module Chinchilla
  class Suite
    attr_reader :mounted_at

    def initialize(mounted_at)
      @mounted_at = mounted_at
    end

    def tests
      [Test.new(mounted_at)]
    end
  end
end

module PebbleX
  class Pebble

    attr_accessor :verbose

    def initialize(environment)
      @pebble_cmd = environment.pebble_cmd
    end

    def build
      `#{@pebble_cmd} build`
      exit($?.exitstatus)
    end

  end
end
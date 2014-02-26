module PebbleX
  class Pebble

    attr_accessor :verbose

    def initialize(environment)
      @pebble_cmd = environment.pebble_cmd

      kill_pebble
    end

    def kill_pebble
      `pkill -f python.*pebble`
      sleep(0.5) # phone's Pebble app needs some time before it accepts new connections
    end

    def build
      `#{@pebble_cmd} build`
      $?.exitstatus
    end

    def install
      `#{@pebble_cmd} install`
      $?.exitstatus
    end

    def logs
      `#{@pebble_cmd} logs`
    end

    def debug
      install
      kill_pebble
      logs
    end


  end
end
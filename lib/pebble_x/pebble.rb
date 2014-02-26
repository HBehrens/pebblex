module PebbleX
  class Pebble

    attr_accessor :verbose

    def initialize(environment)
      @pebble_cmd = environment.pebble_cmd
    end

    def sys_call(call)
      `#{call}`
      $?.exitstatus
    end

    def kill_pebble
      sys_call('pkill -f python.*pebble')
      sleep(0.5) # phone's Pebble app needs some time before it accepts new connections
    end

    def pebble_call(args)
      kill_pebble
      sys_call("#{@pebble_cmd} #{args}")
    end

    def build
      pebble_call('build')
    end

    def install
      pebble_call('install')
    end

    def logs
      pebble_call('logs')
    end

    def debug
      r = install
      r == 0 ? logs : r
    end

  end
end
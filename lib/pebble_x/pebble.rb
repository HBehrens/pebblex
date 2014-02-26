module PebbleX
  class Pebble

    attr_accessor :verbose

    def initialize(pebble_sdk=nil)
      @pebble_sdk = pebble_sdk || File.expand_path('../..', `which pebble`)

      unless @pebble_sdk != ''
        raise ArgumentError, "Pebble SDK not found."
      end

      @pebble_bin = File.join(@pebble_sdk, "bin/pebble")
      unless File.exists?(@pebble_bin)
        raise ArgumentError, "Cannot find `pebble` command at #{@pebble_bin}."
      end
    end

    def build
      `#{@pebble_bin} build`
      exit($?.exitstatus)
    end

  end
end
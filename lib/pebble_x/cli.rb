require 'thor'

module PebbleX

  class CLI < Thor

    class_option :verbose, :type => :boolean
    #class_option :version, :type => :boolean, :desc => "Prints version"
    class_option :pebble_sdk, :banner => "<directory>", :desc => "Sets directory of Pebble SDK (default derived from PATH)"

    def self.exit_on_failure?
      true
    end

    desc "version", "Prints the pebblex's version information"
    def version
      puts PebbleX::VERSION
    end
    map %w(-v --version) => :version

    desc "xcode", "Creates an Xcode project file"
    def xcode
      xcode = command_helper PebbleX::Xcode
      xcode.create_project
    end

    desc "build", "Builds pebble project"
    def build
      pebble = command_helper PebbleX::Pebble
      exit(pebble.build)
    end

    desc "debug", "Loads PBW and logs output from connected watch"
    option :phone
    option :pebble_id
    def debug
      pebble = command_helper PebbleX::Pebble
      pebble.phone = options[:phone] if options[:phone]
      pebble.pebble_id = options[:pebble_id] if options[:pebble_id]
      exit(pebble.debug)
    end

    # provide recurring logic (based on command line switches) to separate commands
    no_commands do

      def command_helper(cls)
        cls.new self
      end

      def verbose?
        return options[:verbose]
      end

      def sys_call(call)
        `#{call}`
      end

      def pebble_sdk_dir
        sdk_dir = options[:pebble_sdk]
        unless sdk_dir
          pebble_cmd = sys_call('which pebble').strip
          if pebble_cmd != ''
            sdk_dir = File.expand_path('../..', pebble_cmd)
          end
        end

        unless sdk_dir != ''
          raise ArgumentError, "Make sure the 'pebble' command is on your path or you pass --pebble_sdk."
        end

        return sdk_dir
      end

      def pebble_cmd
        pebble_cmd = File.expand_path('bin/pebble', self.pebble_sdk_dir)
        unless File.exists?(pebble_cmd)
          raise ArgumentError, "Cannot find 'pebble' command at #{pebble_cmd}."
        end
        return pebble_cmd
      end

      def pebblex_cmd
        return $0
      end

    end

  end

end

require 'thor'

module PebbleX

  class CLI < Thor

    class_option :verbose, :type => :boolean

    def self.exit_on_failure?
      true
    end

    desc "xcode", "creates and Xcode project file"
    def xcode
      xcode = PebbleX::Xcode.new
      xcode.verbose = options[:verbose]
      xcode.create_project
    end


    desc "build", "builds pebble project"
    option :pebble_sdk
    def build
      pebble = PebbleX::Pebble.new(options[:pebble_sdk])
      pebble.verbose = options[:verbose]
      pebble.build
    end
  end

end
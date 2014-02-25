require 'thor'

module PebbleX

  class CLI < Thor

    class_option :verbose, :type => :boolean

    desc "xcode", "creates and Xcode project file"
    def xcode
      xcode = PebbleX::Xcode.new
      xcode.verbose = options[:verbose]
      xcode.create_project
    end
  end

end
require 'thor'

module PebbleX

  class CLI < Thor

    desc "xcode", "creates and Xcode project file"
    def xcode
      xcode = PebbleX::Xcode.new
      xcode.create_project
    end
  end

end
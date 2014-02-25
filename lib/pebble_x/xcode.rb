require 'xcodeproj'

module PebbleX
  class Xcode
    attr_accessor :verbose

    def initialize(directory=nil, project_name=nil, pebble_sdk_dir=nil)
      @verbose = false
      @directory = directory || Dir.getwd
      @project_name = project_name || File.basename(@directory)
      pebble_cmd = `which pebble`
      unless pebble_cmd != ''
        raise ArgumentError, "Make sure the 'pebble' command is on your path."
      end

      @pebble_sdk_dir = pebble_sdk_dir || File.expand_path('../..', pebble_cmd)

      unless File.directory?(@directory)
        raise ArgumentError, "The directory '#{@pebble_sdk_dir}' does not exist."
      end

      unless File.exists?(File.join(@directory, 'appinfo.json'))
        raise ArgumentError, "The directory '#{@pebble_sdk_dir}' doesn not contain a Pebble project."
      end
    end

    def create_project
      if @verbose
        puts "creating project in directory #{@directory}"
        puts "using pebble sdk at #{@pebble_sdk_dir}"
      end

      Dir.chdir(@directory) # TODO: popd at the end of this method

      @project = Xcodeproj::Project.new(@project_name+'.xcodeproj')

      # will add pebble sdk headers and build/src/resource_ids.auto.h to search path
      @project.build_configuration_list.set_setting('HEADER_SEARCH_PATHS', [File.join(@pebble_sdk_dir, 'Pebble/include'), 'build'])

      # fake iOS target to provide search path
      ios_target = @project.new_target(:application, 'fake-iOS-target', :ios)

      # TODO: create target to call pebblex command upon build

      # build project groups
      group = @project.main_group.new_group("sources", "src")

      Dir.glob('src/**/*.{c,h,js}').each do |f|
        file = group.new_file(f)
        puts "adding file #{f}" if @verbose
        if File.extname(f) == '.c'
          ios_target.add_file_references([file])
        end
      end

      @project.main_group.new_reference('resources') if File.directory?('resources')
      @project.main_group.new_file('appinfo.json')

      # clean up xcode project ('products' group must remain due to fake iOS target)
      @project.frameworks_group.remove_from_project

      @project.save
    end

  end
end
require 'xcodeproj'

module PebbleX
  class Xcode
    def initialize(environment, directory=nil, project_name=nil)
      @verbose = environment.verbose?
      @directory = directory || Dir.getwd
      @project_name = project_name || File.basename(@directory)
      @pebblex_cmd = environment.pebblex_cmd
      @pebble_sdk_dir = environment.pebble_sdk_dir

      unless File.exists?(File.join(@directory, 'appinfo.json'))
        raise ArgumentError, "The directory '#{@directory}' doesn not contain a Pebble project."
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

      legacy_target = @project.new(Xcodeproj::Project::Object::PBXLegacyTarget)
      legacy_target.name = 'Pebble'
      legacy_target.product_name = 'Pebble'

      legacy_target.build_tool_path = @pebblex_cmd
      legacy_target.build_arguments_string = "build --pebble_sdk=#{@pebble_sdk_dir}"
      @project.targets << legacy_target

      # fake iOS target to provide search path
      ios_target = @project.new_target(:application, 'fake-iOS-target', :ios)

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
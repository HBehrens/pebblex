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
        raise ArgumentError, "The directory '#{@directory}' does not contain a Pebble project."
      end
    end

    def create_project
      if @verbose
        puts "creating project in directory #{@directory}"
        puts "using pebble sdk at #{@pebble_sdk_dir}"
      end

      Dir.chdir(@directory) # TODO: popd at the end of this method

      project_filename = @project_name+'.xcodeproj'
      puts "Creating #{project_filename}"
      project = Xcodeproj::Project.new(project_filename)

      # will add pebble sdk headers and build/src/resource_ids.auto.h to search path
      project.build_configuration_list.set_setting('HEADER_SEARCH_PATHS', [File.join(@pebble_sdk_dir, 'Pebble/include'), 'build'])

      legacy_target = project.new(Xcodeproj::Project::Object::PBXLegacyTarget)
      legacy_target.name = 'Pebble'
      legacy_target.product_name = 'Pebble'

      legacy_target.build_tool_path = @pebblex_cmd
      legacy_target.build_arguments_string = "build --pebble_sdk=#{@pebble_sdk_dir}"

      legacy_target.build_configuration_list = Xcodeproj::Project::ProjectHelper.configuration_list(project, :osx)
      project.targets << legacy_target

      # fake iOS target to provide search path
      ios_target = project.new_target(:application, 'fake-iOS-target', :ios)

      # build project groups
      group = project.main_group.new_group("sources", "src")

      Dir.glob('src/**/*.{c,h,js}').each do |f|
        file = group.new_file(f)
        puts "adding file #{f}" if @verbose
        if File.extname(f) == '.c'
          ios_target.add_file_references([file])
        end
      end

      project.main_group.new_reference('resources') if File.directory?('resources')
      project.main_group.new_file('appinfo.json')

      # clean up xcode project ('products' group must remain due to fake iOS target)
      project.frameworks_group.remove_from_project

      # run configuration for Pebble target
      scheme = Xcodeproj::XCScheme.new
      scheme.add_build_target legacy_target
      launch_action = scheme.instance_variable_get :@launch_action
      launch_action.attributes["useCustomWorkingDirectory"] = "YES"
      launch_action.attributes["customWorkingDirectory"] = @directory
      launch_action.attributes["selectedDebuggerIdentifier"] = ""
      launch_action.attributes["selectedLauncherIdentifier"] = "Xcode.IDEFoundation.Launcher.PosixSpawn"
      path_runnable = launch_action.add_element "PathRunnable"
      path_runnable.attributes["FilePath"] = @pebblex_cmd
      command_line_arguments = launch_action.add_element "CommandLineArguments"
      command_line_argument = command_line_arguments.add_element "CommandLineArgument"
      command_line_argument.attributes["argument"] = "debug --pebble_sdk=#{@pebble_sdk_dir}"
      command_line_argument.attributes["isEnabled"] = "YES"
      # remove unneeded elements
      for s in [:@test_action, :@profile_action].each do
        scheme.doc.elements[1].delete_element(scheme.instance_variable_get s)
      end
      scheme.save_as(project.path, legacy_target.name, false)

      project.save

      project
    end

  end
end
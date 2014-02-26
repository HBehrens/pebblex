require 'rspec'
require 'pebble_x'
require 'tmpdir'

describe 'Xcode' do

  def prepare_fixture(fixture_name)
    dest = File.join(Dir.tmpdir, fixture_name)
    src = File.join(File.dirname(__FILE__), 'fixtures', fixture_name)

    FileUtils.rm_rf(dest)
    FileUtils.copy_entry(src, dest, remove_destination=true)
    dest
  end


  def project_with_js
    @project_with_js ||= prepare_fixture('project_with_js')
  end
  @project_with_js = nil

  e = nil

  before do
    e = double("environment")
    @project_with_js = nil
    expect(e).to receive(:verbose?) {false}
    expect(e).to receive(:pebble_sdk_dir) {'path/to/pebble_sdk'}
    expect(e).to receive(:pebblex_cmd) {'path/to/pebblex'}
  end

  describe 'initialize' do
    it 'asks environment' do
      PebbleX::Xcode.new(e, project_with_js, 'some_name')
    end

    it 'fails on wrong directory' do
      expect{PebbleX::Xcode.new(e, 'any directory', 'some_name')}.to raise_error
    end
  end

  describe 'create_project' do

    it 'creates files' do
      x = PebbleX::Xcode.new(e, project_with_js, 'some_name')
      p = x.create_project
      expect(p).to be_a(Xcodeproj::Project)
      expect(File).to exist(File.join(project_with_js, 'some_name.xcodeproj', 'project.pbxproj'))
    end

  end

end
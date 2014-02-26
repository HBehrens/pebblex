require 'rspec'
require 'pebble_x'

describe 'Pebble' do
  e = nil

  before(:each) do
    e = double("environment")
    expect(e).to receive(:pebble_cmd) {'path/to/pebble'}
  end

  describe 'initialize' do
    it 'asks environment' do
      PebbleX::Pebble.new(e)
    end
  end

  describe 'pebble_call' do
    it 'kills pebble and calls system' do
      p = PebbleX::Pebble.new(e)
      expect(p).to receive(:kill_pebble)
      expect(p).to receive(:sys_call).with('path/to/pebble foo')
      p.pebble_call('foo')
    end
  end

  describe 'debug' do

    it 'calls install and logs' do
      p = PebbleX::Pebble.new(e)
      expect(p).to receive(:install).and_return(0)
      expect(p).to receive(:logs).and_return(3)
      expect(p.debug).to eq 3
    end

    it 'aborts if install fails' do
      p = PebbleX::Pebble.new(e)
      expect(p).to receive(:install).and_return(1)
      expect(p).to_not receive(:logs)
      expect(p.debug).to eq 1
    end

  end
end
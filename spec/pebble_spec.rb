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

    it 'ignores phone and pebble-id if no connection required' do
      p = PebbleX::Pebble.new(e)
      p.phone = 'phone'
      p.pebble_id = 'pebble_id'
      expect(p).to receive(:kill_pebble)
      expect(p).to receive(:sys_call).with('path/to/pebble foo')
      p.pebble_call('foo', false)
    end

    it 'passes phone if connection required' do
      p = PebbleX::Pebble.new(e)
      p.phone = '1234'
      expect(p).to receive(:kill_pebble)
      expect(p).to receive(:sys_call).with('path/to/pebble foo --phone=1234')
      p.pebble_call('foo', true)
    end

    it 'passes pebble-id if connection required' do
      p = PebbleX::Pebble.new(e)
      p.pebble_id = 'some_id'
      expect(p).to receive(:kill_pebble)
      expect(p).to receive(:sys_call).with('path/to/pebble foo --pebble_id=some_id')
      p.pebble_call('foo', true)
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


  it 'processes sys_call_output' do
      p = PebbleX::Pebble.new(e)
      allow(p).to receive(:pwd).and_return '/path/to/project'
      expect(p.process_sys_call_line nil).to eq nil
      expect(p.process_sys_call_line '').to eq ''

      error_in = "../src/test.c:12:5: error: implicit declaration of function 'text_layer_set_text2'"
      error_out = "/path/to/project/src/test.c:12:5: error: implicit declaration of function 'text_layer_set_text2'"
      expect(p.process_sys_call_line error_in).to eq error_out

      warning_in = "../src/test.c:11:13: warning: unused variable 'i' [-Wunused-variable]"
      warning_out = "/path/to/project/src/test.c:11:13: warning: unused variable 'i' [-Wunused-variable]"
      expect(p.process_sys_call_line warning_in).to eq warning_out
  end
end
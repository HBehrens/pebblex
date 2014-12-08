module PebbleX
  class Pebble

    attr_accessor :verbose
    attr_accessor :phone
    attr_accessor :pebble_id

    def initialize(environment)
      @pebble_cmd = environment.pebble_cmd
    end

    def pwd
      Dir.pwd
    end

    def process_sys_call_line(line)
      return line unless line
      line.gsub %r{^(.*?)(:\d+:(\d+:)? (warning|error):)} do |full_match,foo|
        File.expand_path($1, File.join(pwd, 'build')) + $2
      end
    end

    def sys_call(call)
      r, io = IO.pipe
      fork do
        system(call, out: io, err: io)
        io.puts $?.exitstatus
      end

      io.close
      exit_status = nil
      r.each_line do |l|
        if r.eof?
          exit_status = l.to_i
        else
          l = process_sys_call_line(l)
          $stderr.puts l if l
        end
      end

      exit_status
    end

    def kill_pebble
      sys_call('pkill -f "python.*pebble.py "')
      sleep(0.5) # phone's Pebble app needs some time before it accepts new connections
    end

    def pebble_call(args, requires_connection=false)
      kill_pebble
      args += " --phone=#{@phone}" if requires_connection and @phone
      args += " --pebble_id=#{@pebble_id}" if requires_connection and @pebble_id
      sys_call("#{@pebble_cmd} #{args}")
    end

    def build
      pebble_call('build')
    end

    def install
      pebble_call('install', true)
    end

    def logs
      pebble_call('logs', true)
    end

    def debug
      r = install
      r == 0 ? logs : r
    end

  end
end
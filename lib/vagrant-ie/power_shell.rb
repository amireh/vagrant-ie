require 'net/ssh'

module VagrantIE
  class PowerShell
    def self.open(&block)
      shell = new
      shell.connect

      begin
        yield shell
      ensure
        shell.disconnect
      end
    end

    def connect
      @ssh = Net::SSH.start("localhost", "IEUser", :password => "Passw0rd!", :port => 2222)
    end

    def invoke_file(file:, args: [])
      ssh_exec! <<-SHELL
        PowerShell
          -InputFormat none
          -Sta
          -NonInteractive
          -File "#{file}"
          #{args.join("\n")}
      SHELL
    end

    def disconnect
      @ssh.close
      @ssh = nil
    end

    private

    def strip(string)
      string.gsub(/\n/, ' ').gsub(/[ ]+/, ' ').strip
    end

    def ssh_exec!(command)
      exit_code = nil

      @ssh.open_channel do |channel|
        channel.exec(strip(command)) do |ch, success|
          return false unless success

          channel.on_data do |ch,data|
            STDOUT.puts data
          end

          channel.on_extended_data do |ch,type,data|
            STDERR.puts data
          end

          channel.on_request("exit-status") do |ch,data|
            exit_code = data.read_long
          end
        end
      end

      @ssh.loop

      exit_code == 0
    end
  end
end
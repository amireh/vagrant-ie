require 'socket'
require_relative './power_shell'

module VagrantIE
  class Provisioner < Vagrant.plugin(2, :provisioner)
    def configure(_)
      @config.public_ip_addr ||= Socket.ip_address_list
        .reject(&:unix?)
        .reject(&:ipv4_loopback?)
        .reject(&:ipv6_loopback?)
        .first
          .ip_address
    end

    def provision
      PowerShell.open do |shell|
        shell.invoke_file({
          file: 'C:\Users\IEUser\vagrant-ie\Configure.ps1',
          args: [ @config.public_ip_addr ]
        })
      end
    end
  end
end
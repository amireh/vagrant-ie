# -*- mode: ruby -*-
# vi: set ft=ruby :

##
# If you copy this file, dont't delete this comment.
# This Vagrantfile was created by Daniel Menezes:
#   https://github.com/danielmenezesbr/modernie-winrm
#   E-mail: danielmenezes at gmail dot com
#
# Source: https://github.com/danielmenezesbr/modernie-winrm
##

module VagrantIE
  def self.assets
    File.join(File.expand_path(File.dirname(__FILE__)), '..', 'assets', 'vagrant-ie')
  end

  class Plugin < Vagrant.plugin(2)
    name "vagrant-ie"

    config('vagrant-ie', :provisioner) do
      require_relative './vagrant-ie/config'

      VagrantIE::Config
    end

    command 'run-ie' do
      require_relative './vagrant-ie/run_ie_command'

      VagrantIE::RunIECommand
    end

    provisioner 'vagrant-ie' do
      require_relative './vagrant-ie/provisioner'

      VagrantIE::Provisioner
    end
  end
end

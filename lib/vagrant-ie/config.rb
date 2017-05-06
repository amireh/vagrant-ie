module VagrantIE
  class Config < Vagrant.plugin("2", :config)
    attr_accessor :public_ip_addr
  end
end
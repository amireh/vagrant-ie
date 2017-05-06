# vagrant-ie

This plugin contains a provisioning script that makes it possible to fully
automate the process of launching IE inside a Windows box, headless or not.

The provisioning script does the following:

- Disables the firewall
- Creates a Network with a PRIVATE category for SSH communication
- Disables UAC
- Disables automatic updates
- Inserts a host-mapping entry to allow the box to reach your host

Once a box is provisioned, you can use the `run-ie` command provided by the
plugin to launch the browser at any specific URL.

Please note that this plugin does NOT use WinRM for communication, only ssh.

## Usage

Install the plugin:

    vagrant plugin install vagrant-ie

Then amend your Vagrantfile configuration:

```ruby
# Vagrantfile
require 'vagrant-ie'

Vagrant.configure(2) do |config|
  # You MUST provision the assets of the plugin; this includes the PowerShell
  # and Task Scheduler task scripts needed for operation.
  config.vm.provision "file", source: VagrantIE.assets, destination: "c:/Users/IEUser"

  # Register the provisioner:
  config.vm.provision "shell", type: "vagrant-ie"
end
```

Then re-provision your node if it's an existing box:

    vagrant up --provision

And finally, launch IE:

    vagrant run-ie --kiosk http://www.google.com

## Options

#### `public_ip_addr: String`

Indicates the public IP to map as the `upstream` hostname in the box.

```ruby
config.vm.provision "shell", type: "vagrant-ie" do |ie|
  ie.public_ip_addr = '192.168.1.1'
end
```

Defaults to: the public IP of the first non-loopback ethernet interface of the
host.

## Visiting pages on the host

The provisioning script automatically tries to infer your host's public IP and
exposes it to the client. It will be mapped to the host name `upstream`, so for
example if you have a service running on port `9876` of your host (e.g. Karma) you can visit it in IE like this:

    vagrant run-ie http://upstream:9876/some_page.html

## Credits

Thanks to the authors of the following resources which helped me set this up:

- https://github.com/danielmenezesbr/modernie-winrm
- https://gist.github.com/anthonysterling/7cb85670b36821122a4a
- https://gist.github.com/andreptb/57e388df5e881937e62a
- https://github.com/boxcutter/windows

## License

Copyright 2017 Ahmad Amireh <ahmad@amireh.net>

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
require_relative './power_shell'

module VagrantIE
  class RunIECommand < Vagrant.plugin(2, :command)
    def execute
      options = {
        'kiosk' => true
      }

      opts = OptionParser.new do |o|
        o.banner = "Usage: vagrant run-ie [options] URL"

        o.on('--embedding') { |v| options['embedding'] = v }
        o.on('--extoff') { |v| options['extoff'] = v }
        o.on('--[no-]frame-merging') { |v| options['frame-merging'] = v }
        o.on('--[no-]session-merging') { |v| options['session-merging'] = v }
        o.on('--no-hang-recovery') { |v| options['hang-recovery'] = v }
        o.on('--private') { |v| options['private'] = v }
        o.on('-k', '--[no-]kiosk') { |v| options['kiosk'] = v }
      end

      argv = parse_options(opts)

      return unless argv

      PowerShell.open do |shell|
        shell.invoke_file({
          file: 'C:\Users\IEUser\vagrant-ie\RunIE.ps1',
          args: map_arguments(options).concat([
            argv[0]
          ])
        })
      end
    end

    protected

    def map_arguments(options)
      args = []

      %w[ embedding extoff private ].each do |literal|
        if options[literal] == true
          args << "-#{literal}"
        end
      end

      if options['kiosk']
        args << '-k'
      end

      if options['session-merging'] == true
        args << '-sessionmerging'
      else
        args << '-nosessionmerging'
      end

      if options['frame-merging'] == true
        args << '-framemerging'
      else
        args << '-noframemerging'
      end

      args
    end
  end
end
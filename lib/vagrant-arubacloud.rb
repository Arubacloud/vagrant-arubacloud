require 'vagrant/vagrant-arubacloud/version'
require 'vagrant-arubacloud/plugin'

module Vagrant
  module Arubacloud

    # This initializes the logging so that our logs are outputted at
    # the same level as Vagrant core logs.
    def self.init_logging
      # Initialize logging
      level = nil
      begin
        level = Log4r.const_get(ENV['VAGRANT_LOG'].upcase)
      rescue NameError
        # This means that the logging constant wasn't found,
        # which is fine. We just keep `level` as `nil`. But
        # we tell the user.
        level = nil
      end

      # Some constants, such as "true" resolve to booleans, so the
      # above error checking doesn't catch it. This will check to make
      # sure that the log level is an integer, as Log4r requires.
      level = nil unless level.is_a?(Integer)

      # Set the logging level on all "vagrant" namespaced
      # logs as long as we have a valid level.
      if level
        logger = Log4r::Logger.new('vagrant_arubacloud')
        logger.outputters = Log4r::Outputter.stderr
        logger.level = level
        logger = nil
      end
    end
  end
end

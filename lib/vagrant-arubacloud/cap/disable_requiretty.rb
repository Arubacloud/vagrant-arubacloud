module Cap
  class DisableRequireTty
    def self.disable_requiretty(machine)
      output = ''
      command = 'sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers'

      machine.communicate.execute(command) do |type, data|
        output += data if type == :stdout
      end
      output.chomp!
    end
  end
end
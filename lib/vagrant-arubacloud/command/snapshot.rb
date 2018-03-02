require 'optparse'
require 'vagrant-arubacloud/action'
require 'fog/arubacloud'

module VagrantPlugins
    module Command
      class Snapshot < Vagrant.plugin('2', :command)
        def self.synopsis
          'implement snapshot for vagrant-arubacloud '
        end
        def execute
          options = {:snapop => nil, :namevm => nil}
          myparser = OptionParser.new do |opts|
            opts.banner = "Usage: vagrant snapshot  -t [create|delete|restore|list] -n name_server"
     	    opts.on('-n', '--name name', 'Name server of virtual machine') do |name|
		options[:namevm] = name;
 	    end
     	    opts.on('-t', '--type type', 'Type of snapshot : create|delete|restore|list') do |type|
		options[:snapop] = type;
 	    end
      	    opts.on('-h', '--help', 'Displays Help') do
	      puts opts
	      return
	    end
          end

          myparser.parse!

          if options[:namevm] == nil
	    puts 'Name of VM is missing'
            return 
          end
          if options[:snapop] == nil
	    puts "Type of action:  'create,delete,restore,list'  is missing"
            return 
          end
          ck1 = ["create", "delete", "restore", "list"].include? options[:snapop]
          if !ck1
	    puts 'Valid option type are:  create,delete,restore,list '
            return
          end

          not_found = true
          with_target_vms( nil, :provider => :arubacloud) do |machine|
            # if not machine.id....
            if machine.id == nil
               next
            end
            config1 = machine.provider_config
            #if no url in config....
            unless  config1.url 
              machine.ui.info(" [dc?] " +  I18n.t('vagrant_arubacloud.wrong_dc')) 
              return 
            end

            arubacloud_dc = config1.endpoint
            myprefix = "[#{arubacloud_dc}] "
            params = {
              :provider => :arubacloud,
              :arubacloud_username => config1.arubacloud_username,
              :arubacloud_password => config1.arubacloud_password,
              :url => config1.url
            }
            
            envx = Fog::Compute.new params
            server = envx.servers.get(machine.id)
            if server.name ==  options[:namevm]
            
              machine.ui.info(myprefix  +  I18n.t('vagrant_arubacloud.connect_to_dc'))
              machine.ui.info(myprefix + I18n.t('vagrant_arubacloud.snapshot_req_type') + " '#{options[:snapop]}'" +  " target id:#{machine.id}" )
              not_found = false
              case options[:snapop]
              # output if exist date creation and date expire for snapshot
              when "list"
                begin
                  myreq = server.list_snapshot
                  if myreq["Success"] 
                    machine.ui.info(myprefix + 'snapshot ' + I18n.t('vagrant_arubacloud.snapshot_info_create') + "  #{myreq['credate']} " + I18n.t('vagrant_arubacloud.snapshot_info_expired') + "  #{myreq['expdate']} " )
                  else
                    machine.ui.warn(myprefix + I18n.t('vagrant_arubacloud.snapshot_info_not_found'))
                  end 
                rescue Fog::ArubaCloud::Errors::RequestError => e
                  message = ''
                  error = nil
                  @logger.debug(e.inspect.to_yaml)
                  machine.ui.warn(myprefix + " *ERR* list response message: #{e.response.to_yaml}")
                end
              # creation of snapshot ....
              when "create"
                if server.state == Fog::ArubaCloud::Compute::Server::RUNNING
                #
                # if state active and request snapshot create ...
                #
                  begin
                    myreq = server.create_snapshot
                    if myreq 
                      machine.ui.info(myprefix + I18n.t('vagrant_arubacloud.snapshot_created'))
                    else
                      machine.ui.warn(myprefix + I18n.t('vagrant_arubacloud.snapshot_create_err_fog'))
                    end 
                  rescue Fog::ArubaCloud::Errors::RequestError => e
                    message = ''
                    error = nil
                    @logger.debug(e.inspect.to_yaml)
                    machine.ui.warn(myprefix + " *ERROR* response message: #{e.response.to_yaml}")
                    #raise error
                  end
                #  
                else
                  machine.ui.warn(myprefix  + I18n.t('vagrant_arubacloud.snapshot_create_err_not_on'))
                end
              # delete of snapshot...
              when "delete"
                #
                # if snapshot delete ... 
                #  
                begin
                  myreq = server.delete_snapshot
                  if myreq 
                    machine.ui.info(myprefix + I18n.t('vagrant_arubacloud.snapshot_deleted'))
                  else
                    machine.ui.warn(myprefix + I18n.t('vagrant_arubacloud.snapshot_delete_err_fog'))
                  end 
                rescue Fog::ArubaCloud::Errors::RequestError => e
                  message = ''
                  error = nil
                  @logger.debug(e.inspect.to_yaml)
                  machine.ui.warn(myprefix + " *ERROR* response message: #{e.response.to_yaml}")
                  #raise error
                end
              # if vm is power off and esiste a snapshot resorre vm from snapshot
              # (waring : the machine is not power on after restart and snapshot image is removed) 
              when "restore"
                if server.state == Fog::ArubaCloud::Compute::Server::STOPPED
                  #
                  # if state stopped (power off) and requets restore
                  # WARNING : the snapshot file is removed after restore 
                  #
                  begin
                    myreq = server.apply_snapshot
                    if myreq 
                      machine.ui.info(myprefix + I18n.t('vagrant_arubacloud.snapshot_restored'))
                    else
                      machine.ui.warn(myprefix + I18n.t('vagrant_arubacloud.snapshot_restore_err_fog'))
                    end 
                  rescue Fog::ArubaCloud::Errors::RequestError => e
                    message = ''
                    error = nil
                    @logger.debug(e.inspect.to_yaml)
                    machine.ui.warn(myprefix + " *ERROR* response message: #{e.response.to_yaml}")
                    #raise error
                  end
                else
                  machine.ui.warn(myprefix  + I18n.t('vagrant_arubacloud.snapshot_restore_err_not_off'))
                end

              else
                machine.ui.warn(myprefix  + I18n.t('vagrant_arubacloud.snapshot_type_unknow') + " :#{options[:snapop]}" )
              end

            end  # test if found machine.id

          end #

          if not_found
            puts "==> ??? [dc?] " + I18n.t("vagrant_arubacloud.snapshot_server_unknow") + " :#{options[:namevm]}" 
          end  
          
        end
      end
    end
end




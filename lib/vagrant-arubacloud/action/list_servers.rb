module VagrantPlugins
  module ArubaCloud
    module Action
      class ListServers

         def initialize(app, env)
          @app = app
         end

         def call(env )
          config = env[:machine].provider_config
          arubacloud_dc = config.endpoint
          compute_service = env[:arubacloud_compute]

          vm_in_dc  = compute_service.servers
          server_fnd = vm_in_dc.select{ |s|  (s.id).to_i == (env[:machine].id).to_i }

          if server_fnd && server_fnd.length == 1
            server = server_fnd[0]
            server.get_server_details
            env[:machine].ui.info('%-6s %-20s %-8s %-12s %-14s %s' % [arubacloud_dc, server.name, server.id, server.state, Fog::ArubaCloud::Compute::Server::STATE_DES[server.state],  server.smart_ipv4] )
          end

          if config.reserved_status == "other"
            #
            # output all info relate VM found in current DC , but not found in '.vagrant' directory
            #
            ll = env[:machine].name.length
            ui_ext = Vagrant::UI::Prefixed.new(  Vagrant::UI::Colored.new, "-".center(ll) )
            if server && server.name
              config.reserved_list_owned << server.name
            end
            server_xs = vm_in_dc.select{ |s|  not (config.reserved_list_owned.include? s.name)}
            server_xs.sort_by(&:name).each do |server|
              server.get_server_details
              ui_ext.detail('%-6s %-20s %-8s %-12s %-14s %s' % [arubacloud_dc, server.name, server.id, server.state, Fog::ArubaCloud::Compute::Server::STATE_DES[server.state],  server.smart_ipv4] )
            end
            config.reserved_list_owned  =  []
          else
             if server && server.name
               config.reserved_list_owned  =  server.name
             else
               config.reserver_list_owned = ""
             end
          end

          @app.call(env)
        end
      end
    end
  end
end

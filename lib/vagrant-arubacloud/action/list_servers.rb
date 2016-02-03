module VagrantPlugins
  module ArubaCloud
    module Action
      class ListServers
        def initialize(app, env)
          @app = app
        end

        def call(env)
          compute_service = env[:arubacloud_compute]
          env[:ui].info ('%-20s %-20s %s' % ['Server Name', 'State', 'IPv4 address'])
          compute_service.servers.sort_by(&:name).each do |server|
            # Ask fog for the full details list
            server.get_server_details
            # Output the result
            env[:ui].info ('%-20s %-20s %s' % [server.name, server.state, server.smart_ipv4])
          end
          @app.call(env)
        end
      end
    end
  end
end

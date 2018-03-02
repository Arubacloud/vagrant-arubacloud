module VagrantPlugins
  module ArubaCloud
    module Action
      class ListTemplates
        def initialize(app, env)
          @app = app
        end

        def call(env)
          config = env[:machine].provider_config
          arubacloud_dc = config.endpoint
          compute_service = env[:arubacloud_compute]
          env[:ui].info ('%-5s %-40s %-60s %-20s %s' % ['DC', 'Template Name', 'Description', 'ID', 'Hypervisor ID'])
          compute_service.templates.sort_by(&:hypervisor).each do |template|
          env[:ui].info ('%-5s %-40s %-60s %-20s %s' % [arubacloud_dc, template.name,
                                                     template.description,
                                                     template.id,
                                                     enum_hypervisor_id(template.hypervisor)])
          end
          @app.call(env)
        end

        def enum_hypervisor_id(id)
          case id
            when 1 then return 'Pro Hyper-V'
            when 2 then return 'Pro VmWare'
            when 3 then return 'Pro Hyper-V LowCost'
            when 4 then return 'Pro Smart'
            else
              return 'Not Found'
          end
        end
      end
    end
  end
end
